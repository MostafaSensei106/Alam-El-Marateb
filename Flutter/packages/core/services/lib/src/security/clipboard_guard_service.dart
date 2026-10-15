import 'dart:async';

import 'package:alam_el_marateb_constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'audit/base_audit_logger.dart';
import 'audit/security_event.dart';

/// Domain port for clipboard handling with auto-clear of secrets.
///
/// Single responsibility: copy text, and shorten the lifetime of sensitive
/// content in the OS clipboard. This reduces exposure; it is NOT a guarantee
/// that every OS-level copy (keyboard caches, managers) is purged.
abstract interface class BaseClipboardGuardService {
  Future<void> copySensitive(String text);
  Future<void> copy(String text);
  Future<void> clear({bool auto = false});
}

/// Seam around the platform clipboard so the guard stays unit-testable.
abstract interface class ClipboardBackend {
  Future<void> setText(String text);
  Future<String?> getText();
}

final class PlatformClipboardBackend implements ClipboardBackend {
  const PlatformClipboardBackend();

  @override
  Future<void> setText(String text) =>
      Clipboard.setData(ClipboardData(text: text));

  @override
  Future<String?> getText() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }
}

@LazySingleton(as: BaseClipboardGuardService)
final class ClipboardGuardService implements BaseClipboardGuardService {
  ClipboardGuardService(this._audit)
    : _clipboard = const PlatformClipboardBackend(),
      _clearDelay = SecurityConfigs.clipboardClearDelay;

  @visibleForTesting
  ClipboardGuardService.testing(
    this._audit, {
    this._clipboard = const PlatformClipboardBackend(),
    this._clearDelay = SecurityConfigs.clipboardClearDelay,
  });

  final BaseAuditLogger _audit;
  final ClipboardBackend _clipboard;
  final Duration _clearDelay;

  Timer? _clearTimer;
  String? _pendingSensitive;

  @override
  Future<void> copySensitive(String text) async {
    await _clipboard.setText(text);
    _audit.audit(const ClipboardSensitiveCopied());
    _clearTimer?.cancel();
    _pendingSensitive = text;
    _clearTimer = Timer(_clearDelay, () {
      // ignore: discarded_futures
      clear(auto: true);
    });
  }

  @override
  Future<void> copy(String text) async {
    _clearTimer?.cancel();
    _pendingSensitive = null;
    await _clipboard.setText(text);
  }

  @override
  Future<void> clear({bool auto = false}) async {
    _clearTimer?.cancel();
    _clearTimer = null;
    final expected = _pendingSensitive;
    _pendingSensitive = null;
    try {
      // Never wipe content the user copied after us: only clear when the
      // clipboard still holds exactly what we put there.
      if (auto && expected != null) {
        final current = await _clipboard.getText();
        if (current != expected) return;
      }
      await _clipboard.setText('');
    } catch (error, stack) {
      _audit.report(
        error,
        stack,
        context: 'clipboard.clear',
        fields: {'auto': auto},
      );
      return;
    }
    _audit.audit(ClipboardCleared(auto: auto));
  }
}
