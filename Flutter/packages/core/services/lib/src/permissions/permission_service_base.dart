import 'package:permission_handler/permission_handler.dart';

abstract class PermissionServiceBase {
  /// Checks if a specific [permission] is already granted.
  Future<bool> isGranted(Permission permission);

  /// Returns the current [PermissionStatus] of a specific [permission].
  Future<PermissionStatus> getStatus(Permission permission);

  /// Requests a single [permission].
  Future<PermissionStatus> requestPermission(Permission permission);

  /// Requests multiple [permissions] in a single prompt.
  Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  );

  /// Checks if a [permission] was permanently denied by the user.
  /// Useful for showing a custom dialog pointing to App Settings.
  Future<bool> isPermanentlyDenied(Permission permission);

  /// Returns `true` if the OS indicates a rationale dialog should be shown
  /// explaining why the feature requires this [permission] (Android).
  Future<bool> shouldShowRequestPermissionRationale(Permission permission);

  /// Requests Notification permissions (handles iOS & Android 13+ POST_NOTIFICATIONS).
  Future<bool> requestNotificationPermission();

  /// Requests Camera permission.
  Future<bool> requestCameraPermission();

  /// Requests Photos / Gallery access.
  /// (Handles Android 13+ READ_MEDIA_IMAGES vs legacy READ_EXTERNAL_STORAGE).
  Future<bool> requestPhotosPermission();

  /// Requests Location permissions.
  /// Set [isBackground] to `true` if background location is required.
  Future<PermissionStatus> requestLocationPermission({
    bool isBackground = false,
  });

  /// Requests Bluetooth permissions (iOS & Android 12+ BLUETOOTH_SCAN/CONNECT).
  Future<bool> requestBluetoothPermissions();

  /// Requests Microphone permission.
  Future<bool> requestMicrophonePermission();

  /// Checks if the underlying hardware/system service is enabled
  /// (e.g. GPS service enabled, Bluetooth turned on).
  Future<bool> isServiceEnabled(PermissionWithService permission);

  /// Opens the device app settings screen so the user can grant denied permissions.
  Future<bool> openAppSettings();
}
