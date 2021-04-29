import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rec/Permissions/PermissionProvider.dart';

class CameraPermissionProvider extends PermissionProvider {
  CameraPermissionProvider()
      : super(
          Permission.camera,
          icon: Icons.camera_alt_outlined,
          title: 'CAMERA_PERMISSION_TITLE',
          subtitle: 'CAMERA_PERMISSION_SUBTITLE',
          buttonAcceptText: 'CAMERA_PERMISSION_ACCEPT',
          buttonDeclineText: 'CAMERA_PERMISSION_DECLINE',
        );
}
