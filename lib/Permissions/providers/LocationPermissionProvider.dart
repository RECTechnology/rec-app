import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rec/Permissions/PermissionProvider.dart';

class LocationPermissionProvider extends PermissionProvider {
  LocationPermissionProvider()
      : super(
          Permission.location,
          icon: Icons.location_on,
          title: 'LOCATION_PERMISSION_TITLE',
          subtitle: 'LOCATION_PERMISSION_SUBTITLE',
          buttonAcceptText: 'LOCATION_PERMISSION_ACCEPT',
          buttonDeclineText: 'LOCATION_PERMISSION_DECLINE',
          permanentlyDeniedMessage: 'LOCATION_PERMISSION_PERMANENTLY_DENIED',
        );
}
