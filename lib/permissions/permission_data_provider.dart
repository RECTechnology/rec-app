import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rec/permissions/permission_data.dart';

/// Holds instances of [PermissionData]
class PermissionDataProvider {
  static PermissionData qr = PermissionData.fromName(
    Permission.camera,
    name: 'QR',
    icon: Icons.qr_code_scanner,
  );
  static PermissionData camera = PermissionData.fromName(
    Permission.camera,
    name: 'CAMERA',
    icon: Icons.camera_alt_outlined,
  );
  static PermissionData contacts = PermissionData.fromName(
    Permission.contacts,
    name: 'CONTACTS',
    icon: Icons.import_contacts_outlined,
  );
  static PermissionData location = PermissionData.fromName(
    Permission.location,
    name: 'LOCATION',
    icon: Icons.location_on,
  );
}
