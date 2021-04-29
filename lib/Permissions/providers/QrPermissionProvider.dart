import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rec/Permissions/PermissionProvider.dart';

class QrPermissionProvider extends PermissionProvider {
  QrPermissionProvider()
      : super(
          Permission.camera,
          icon: Icons.qr_code_scanner,
          title: 'QR_PERMISSION_TITLE',
          subtitle: 'QR_PERMISSION_SUBTITLE',
          buttonAcceptText: 'QR_PERMISSION_ACCEPT',
          buttonDeclineText: 'QR_PERMISSION_DECLINE',
        );
}
