import 'package:permission_handler/permission_handler.dart';

abstract class BasePermissionService {
  /// Checks if a specific permission is already granted.
  Future<bool> isPermissionGranted(Permission permission);

  /// Requests a specific permission.
  Future<PermissionStatus> requestPermission(Permission permission);

  /// Requests multiple permissions.
  Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  );

  /// Requests notification permissions on Android/iOS.
  Future<bool> requestNotificationPermission();

  /// Opens the device app settings screen.
  Future<bool> openAppSettings();
}
