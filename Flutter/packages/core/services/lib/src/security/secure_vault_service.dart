import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:alam_el_marateb_constants/constants.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'audit/base_audit_logger.dart';
import 'audit/security_event.dart';
import 'failures/security_failures.dart';

/// Domain port for authenticated encryption of sensitive payloads.
///
/// Key-management model (deliberate, non-negotiable):
/// - Operational keys are random 256-bit values used DIRECTLY with
///   AES-256-GCM. No KDF is applied to them — stretching a full-entropy
///   random key adds cost without adding security.
/// - Argon2id is used ONLY when the key material starts as a human
///   passphrase ([deriveKeyAndStore], e.g. master-password / export flows
///   per policy), where it slows offline guessing. It runs once per
///   derivation; derived keys are cached in memory until [purgeMemory].
///
/// Failures are typed ([VaultFailure]), never raw platform exceptions.
/// Every state change emits a typed [SecurityEvent] with zero secrets.
abstract interface class BaseSecureVaultService {
  /// Derives a 256-bit key from [passphrase] with Argon2id and pins it in
  /// memory under [keyId]. The passphrase reference must be dropped by the
  /// caller immediately after `await` returns.
  Future<void> deriveKeyAndStore({
    required String keyId,
    required String passphrase,
  });

  /// Encrypts [plaintext] with AES-256-GCM. Returns base64
  /// `nonce|ciphertext|mac`.
  Future<String> encrypt({required String keyId, required String plaintext});

  /// Decrypts a payload produced by [encrypt].
  /// Throws [VaultFailure.invalidPayload] on tamper/format errors.
  Future<String> decrypt({required String keyId, required String payload});

  /// Removes one vault entry from memory and secure storage.
  Future<void> wipe(String keyId);

  /// Drops all in-memory keys (call on background/lock). Disk copies stay
  /// so the session can re-hydrate after unlock.
  void purgeMemory();
}

@LazySingleton(as: BaseSecureVaultService)
final class SecureVaultService implements BaseSecureVaultService {
  SecureVaultService(this._secureStorage, this._audit);

  final FlutterSecureStorage _secureStorage;
  final BaseAuditLogger _audit;

  static final _cipher = AesGcm.with256bits();

  final Map<String, SecretKey> _memoryKeys = {};

  @override
  Future<void> deriveKeyAndStore({
    required String keyId,
    required String passphrase,
  }) async {
    try {
      final salt = await _loadOrCreateSalt();
      final kdf = Argon2id(
        parallelism: SecurityConfigs.argon2Parallelism,
        memory: SecurityConfigs.argon2MemoryKiB,
        iterations: SecurityConfigs.argon2Iterations,
        hashLength: SecurityConfigs.argon2HashLength,
      );
      final key = await kdf.deriveKey(
        secretKey: SecretKey(utf8.encode(passphrase)),
        nonce: salt,
      );
      _memoryKeys[keyId] = key;
      await _secureStorage.write(
        key: '${SecurityConfigs.vaultKeyPrefix}$keyId',
        value: base64Encode(await key.extractBytes()),
      );
      _audit.audit(const VaultKeyDerived());
    } catch (error, stack) {
      _audit.report(
        error,
        stack,
        context: 'vault.deriveKey',
        fields: {'keyId': keyId},
      );
      throw const VaultFailure.operationFailed('deriveKey');
    }
  }

  @override
  Future<String> encrypt({
    required String keyId,
    required String plaintext,
  }) async {
    try {
      final key = await _resolveKey(keyId);
      final nonce = _randomBytes(_cipher.nonceLength);
      final box = await _cipher.encrypt(
        utf8.encode(plaintext),
        secretKey: key,
        nonce: nonce,
      );
      final combined =
          (BytesBuilder()
                ..add(box.nonce)
                ..add(box.cipherText)
                ..add(box.mac.bytes))
              .toBytes();
      _audit.audit(VaultEncrypted(keyId));
      return base64Encode(combined);
    } on VaultFailure {
      rethrow;
    } catch (error, stack) {
      _audit.report(
        error,
        stack,
        context: 'vault.encrypt',
        fields: {'keyId': keyId},
      );
      throw const VaultFailure.operationFailed('encrypt');
    }
  }

  @override
  Future<String> decrypt({
    required String keyId,
    required String payload,
  }) async {
    try {
      final key = await _resolveKey(keyId);
      final bytes = base64Decode(payload);
      const macLength = 16;
      final nonceLength = _cipher.nonceLength;
      if (bytes.length < nonceLength + macLength + 1) {
        throw const VaultFailure.invalidPayload();
      }
      final box = SecretBox(
        bytes.sublist(nonceLength, bytes.length - macLength),
        nonce: bytes.sublist(0, nonceLength),
        mac: Mac(bytes.sublist(bytes.length - macLength)),
      );
      final clear = await _cipher.decrypt(box, secretKey: key);
      _audit.audit(VaultDecrypted(keyId));
      return utf8.decode(clear);
    } on VaultFailure {
      rethrow;
    } on FormatException {
      throw const VaultFailure.invalidPayload();
    } catch (error, stack) {
      _audit.report(
        error,
        stack,
        context: 'vault.decrypt',
        fields: {'keyId': keyId},
      );
      throw const VaultFailure.operationFailed('decrypt');
    }
  }

  @override
  Future<void> wipe(String keyId) async {
    _memoryKeys.remove(keyId);
    try {
      await _secureStorage.delete(
        key: '${SecurityConfigs.vaultKeyPrefix}$keyId',
      );
    } catch (error, stack) {
      _audit.report(
        error,
        stack,
        context: 'vault.wipe',
        fields: {'keyId': keyId},
      );
      throw const VaultFailure.operationFailed('wipe');
    }
    _audit.audit(VaultWiped(keyId));
  }

  @override
  void purgeMemory() {
    final count = _memoryKeys.length;
    _memoryKeys.clear();
    _audit.audit(VaultKeysPurged(count));
  }

  Future<SecretKey> _resolveKey(String keyId) async {
    final cached = _memoryKeys[keyId];
    if (cached != null) return cached;
    try {
      final stored = await _secureStorage.read(
        key: '${SecurityConfigs.vaultKeyPrefix}$keyId',
      );
      if (stored == null) throw const VaultFailure.keyUnavailable();
      final key = SecretKey(base64Decode(stored));
      _memoryKeys[keyId] = key;
      return key;
    } on VaultFailure {
      rethrow;
    } catch (error, stack) {
      _audit.report(
        error,
        stack,
        context: 'vault.resolveKey',
        fields: {'keyId': keyId},
      );
      throw const VaultFailure.keyUnavailable();
    }
  }

  Future<List<int>> _loadOrCreateSalt() async {
    final stored = await _secureStorage.read(key: SecurityConfigs.vaultSaltKey);
    if (stored != null) return base64Decode(stored);
    final salt = _randomBytes(16);
    await _secureStorage.write(
      key: SecurityConfigs.vaultSaltKey,
      value: base64Encode(salt),
    );
    return salt;
  }

  List<int> _randomBytes(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (_) => random.nextInt(256));
  }
}
