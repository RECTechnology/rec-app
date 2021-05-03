import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rec/Permissions/PermissionProvider.dart';

class LocationPermissionProvider extends PermissionProvider {
  LocationPermissionProvider()
      : super(
          Permission.location,
          icon: Icons.location_on,
          title: 'PERMISSIONS_PERMISSION_TITLE',
          subtitle: 'PERMISSIONS_PERMISSION_SUBTITLE',
          buttonAcceptText: 'PERMISSIONS_PERMISSION_ACCEPT',
          buttonDeclineText: 'PERMISSIONS_PERMISSION_DECLINE',
        );
}
