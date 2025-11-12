import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class PermissionService {
  /// Request camera permission
  static Future<bool> requestCameraPermission() async {
    final status = await permission_handler.Permission.camera.request();
    return status.isGranted;
  }

  /// Request photos permission
  static Future<bool> requestPhotosPermission() async {
    // Try photos permission first (Android 13+)
    final photosStatus = await permission_handler.Permission.photos.request();
    if (photosStatus.isGranted) {
      return true;
    }

    // Fallback to storage permission for older Android versions
    final storageStatus = await permission_handler.Permission.storage.request();
    return storageStatus.isGranted;
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    final status = await permission_handler.Permission.camera.status;
    return status.isGranted;
  }

  /// Check if photos permission is granted
  static Future<bool> isPhotosPermissionGranted() async {
    // Check photos permission first (Android 13+)
    final photosStatus = await permission_handler.Permission.photos.status;
    if (photosStatus.isGranted) {
      return true;
    }

    // Fallback to storage permission for older Android versions
    final storageStatus = await permission_handler.Permission.storage.status;
    return storageStatus.isGranted;
  }

  /// Request all story permissions
  static Future<Map<String, bool>> requestStoryPermissions() async {
    final results = <String, bool>{};

    // Request camera permission
    results['camera'] = await requestCameraPermission();

    // Request photos permission
    results['photos'] = await requestPhotosPermission();

    return results;
  }

  /// Check all story permissions
  static Future<Map<String, bool>> checkStoryPermissions() async {
    final results = <String, bool>{};

    // Check camera permission
    results['camera'] = await isCameraPermissionGranted();

    // Check photos permission
    results['photos'] = await isPhotosPermissionGranted();

    return results;
  }

  /// Open app settings if permissions are denied
  static Future<void> openAppSettings() async {
    await permission_handler.openAppSettings();
  }
}
