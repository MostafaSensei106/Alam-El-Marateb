import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:services/src/permissions/permission_service_base.dart';

@LazySingleton(as: PermissionServiceBase)
class PermissionHandlerService implements PermissionServiceBase {
  const PermissionHandlerService();

  @override
  Future<bool> isGranted(ph.Permission permission) async {
    return await permission.isGranted;
  }

  @override
  Future<ph.PermissionStatus> getStatus(ph.Permission permission) async {
    return await permission.status;
  }

  @override
  Future<ph.PermissionStatus> requestPermission(
    ph.Permission permission,
  ) async {
    return await permission.request();
  }

  @override
  Future<Map<ph.Permission, ph.PermissionStatus>> requestPermissions(
    List<ph.Permission> permissions,
  ) async {
    return await permissions.request();
  }

  @override
  Future<bool> isPermanentlyDenied(ph.Permission permission) async {
    return await permission.isPermanentlyDenied;
  }

  @override
  Future<bool> shouldShowRequestPermissionRationale(
    ph.Permission permission,
  ) async {
    return await permission.shouldShowRequestRationale;
  }

  @override
  Future<bool> requestNotificationPermission() async {
    final status = await ph.Permission.notification.request();
    return status.isGranted;
  }

  @override
  Future<bool> requestCameraPermission() async {
    final status = await ph.Permission.camera.request();
    return status.isGranted;
  }

  @override
  Future<bool> requestPhotosPermission() async {
    // Automatically selects photos / storage depending on OS version
    final status = await ph.Permission.photos.request();
    return status.isGranted || status.isLimited;
  }

  @override
  Future<ph.PermissionStatus> requestLocationPermission({
    bool isBackground = false,
  }) async {
    final status = await ph.Permission.locationWhenInUse.request();

    if (isBackground && status.isGranted) {
      return await ph.Permission.locationAlways.request();
    }

    return status;
  }

  @override
  Future<bool> requestBluetoothPermissions() async {
    final statuses = await [
      ph.Permission.bluetoothScan,
      ph.Permission.bluetoothConnect,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  @override
  Future<bool> requestMicrophonePermission() async {
    final status = await ph.Permission.microphone.request();
    return status.isGranted;
  }

  @override
  Future<bool> isServiceEnabled(ph.PermissionWithService permission) async {
    return await permission.serviceStatus.isEnabled;
  }

  @override
  Future<bool> openAppSettings() async {
    return await ph.openAppSettings();
  }
}
