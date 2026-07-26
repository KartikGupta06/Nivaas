import 'package:permission_handler/permission_handler.dart';

/// Centralized Permission Service abstraction wrapping permission_handler.
class PermissionService {
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  Future<bool> isCameraGranted() async => await Permission.camera.isGranted;
  Future<bool> isNotificationGranted() async => await Permission.notification.isGranted;
}
