import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import 'base_permission_service.dart';

@LazySingleton(as: BasePermissionService)
class PermissionService implements BasePermissionService {
  @override
  Future<bool> isPermissionGranted(ph.Permission permission) async {
    return permission.isGranted;
  }

  @override
  Future<ph.PermissionStatus> requestPermission(
    ph.Permission permission,
  ) async {
    return permission.request();
  }

  @override
  Future<Map<ph.Permission, ph.PermissionStatus>> requestPermissions(
    List<ph.Permission> permissions,
  ) async {
    return permissions.request();
  }

  @override
  Future<bool> requestNotificationPermission() async {
    final status = await requestPermission(ph.Permission.notification);
    return status.isGranted || status.isProvisional;
  }

  @override
  Future<bool> openAppSettings() async {
    return ph.openAppSettings();
  }
}
