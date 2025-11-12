import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class PermissionDialog extends StatelessWidget {
  final String permissionType;
  final VoidCallback? onRetry;

  const PermissionDialog({
    super.key,
    required this.permissionType,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('story.permission_required'.tr()),
      content: Text(_getPermissionMessage()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('story.cancel'.tr()),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await permission_handler.openAppSettings();
          },
          child: Text('story.open_settings'.tr()),
        ),
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry!();
            },
            child: Text('story.retry'.tr()),
          ),
      ],
    );
  }

  String _getPermissionMessage() {
    switch (permissionType) {
      case 'camera':
        return 'story.camera_permission_message'.tr();
      case 'photos':
        return 'story.photos_permission_message'.tr();
      default:
        return 'story.permission_message'.tr();
    }
  }
}

// Helper function to show permission dialog
Future<void> showPermissionDialog(
  BuildContext context,
  String permissionType,
  VoidCallback? onRetry,
) {
  return showDialog(
    context: context,
    builder:
        (context) =>
            PermissionDialog(permissionType: permissionType, onRetry: onRetry),
  );
}
