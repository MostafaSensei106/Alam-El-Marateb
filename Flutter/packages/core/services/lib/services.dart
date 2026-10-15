library;

// ── Storage (shared prefs / secure / session) ─────────────────────────────
export 'src/shared_prefs/pref_storage_service_base.dart';
export 'src/shared_prefs/shared_prefs_service.dart';
export 'src/shared_prefs/secure_storage_service.dart';
export 'src/shared_prefs/storage_facade.dart';
export 'src/session/user_session_service_base.dart';
export 'src/session/user_session_service.dart';
export 'src/session/session_memory_guard.dart';
export 'src/app_info/models/app_info_model.dart';
export 'src/app_info/interface/base_app_info_service.dart';
export 'src/app_info/interface/base_package_info_adapter.dart';
export 'src/app_info/package_info_plus_adapter.dart';
export 'src/app_info/app_info_service.dart';

// ── Security (audit / vault / clipboard) ──────────────────────────────────
export 'src/security/audit/audit_severity.dart';
export 'src/security/audit/security_event.dart';
export 'src/security/audit/redaction_policy.dart';
export 'src/security/audit/base_audit_logger.dart';
export 'src/security/audit/app_audit_logger.dart';
export 'src/security/failures/security_failures.dart';
export 'src/security/secure_vault_service.dart';
export 'src/security/clipboard_guard_service.dart';

// ── Platform (permissions / notifications / intents) ─────────────────────
export 'src/permissions/permission_service_base.dart';
export 'src/permissions/permission_handler_service.dart';
export 'src/notifications/base_notification_service.dart';
export 'src/notifications/base_local_notification_service.dart';
export 'src/notifications/local_notification_service.dart';
export 'src/notifications/firebase_notification_service.dart';
export 'src/share/base_share_service.dart';
export 'src/share/share_plus_service.dart';
export 'src/url_launcher/base_url_launcher_services.dart';
export 'src/url_launcher/url_launcher_service.dart';
export 'src/attachment_handler/base_attachment_handler_service.dart';
export 'src/attachment_handler/attachment_handler_service.dart';
export 'src/file_opener/base_file_opener_service.dart';
export 'src/file_opener/url_file_opener_service.dart';

// ── UI helpers (theme / toast) ────────────────────────────────────────────
export 'src/theme/theme_service.dart';
export 'src/toast/toast_service_base.dart';
export 'src/toast/toastification_service.dart';

// ── Dependency injection ──────────────────────────────────────────────────
export 'src/di/service_module.dart';
export 'src/di/services_config.dart';
export 'src/di/manual_services.dart';
