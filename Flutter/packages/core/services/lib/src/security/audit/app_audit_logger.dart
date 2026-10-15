import 'dart:developer' as dev;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'base_audit_logger.dart';
import 'redaction_policy.dart';
import 'security_event.dart';

/// Production audit sink: `dev.log` in debug, Crashlytics breadcrumbs in
/// release. Secrets can never reach either sink — events are typed and
/// error paths go through [RedactionPolicy].
@LazySingleton(as: BaseAuditLogger)
final class AppAuditLogger implements BaseAuditLogger {
  // NOTE: intentionally dependency-free. An earlier version took an
  // optional [RedactionPolicy] with a default value, but injectable
  // ignores defaults and generated `gh<RedactionPolicy>()` — an
  // unregistered lookup that crashed every resolution at runtime.
  const AppAuditLogger() : _redaction = const RedactionPolicy();

  final RedactionPolicy _redaction;

  @override
  Future<void> audit(SecurityEvent event) async {
    final safeFields = _redaction.redactMap(event.fields);
    final message = safeFields.isEmpty
        ? 'audit:${event.name}'
        : 'audit:${event.name} $safeFields';
    try {
      if (kDebugMode) {
        dev.log(message, name: 'SECURITY');
      } else {
        await FirebaseCrashlytics.instance.log(message);
      }
    } catch (_) {
      // Logging must never throw.
    }
  }

  @override
  Future<void> report(
    Object error,
    StackTrace stackTrace, {
    required String context,
    Map<String, Object?>? fields,
  }) async {
    final safeError = _redaction.redactError(error);
    final safeFields = _redaction.redactMap(fields);
    final message = safeFields.isEmpty
        ? 'audit-error:$context'
        : 'audit-error:$context $safeFields';
    try {
      if (kDebugMode) {
        dev.log(message, name: 'SECURITY', error: safeError);
      } else {
        await FirebaseCrashlytics.instance.recordError(
          safeError,
          stackTrace,
          reason: context,
        );
      }
    } catch (_) {
      // Logging must never throw.
    }
  }
}
