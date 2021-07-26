import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Hold data for a specific [Permission], with some additional config for
/// displaying it when requesting a permission.
class PermissionData {
  Permission permission;
  IconData icon;
  String title;
  String subtitle;
  String permanentlyDeniedMessage;

  String buttonAcceptText;
  String buttonDeclineText;

  PermissionData(
    this.permission, {
    this.icon,
    this.title,
    this.subtitle,
    this.buttonAcceptText,
    this.buttonDeclineText,
    this.permanentlyDeniedMessage,
  });

  /// Creates a new PermissionData instance,
  /// but all String properties are setup automatically prefixed with a given [name]
  ///
  /// Example:
  /// ```dart
  /// PermissionData.fromName(Permission.camera, 'QR');
  ///
  /// // Will result in:
  /// // title: 'QR_PERMISSION_TITLE',
  /// // subtitle: 'QR_PERMISSION_SUBTITLE',
  /// // buttonAcceptText: 'QR_PERMISSION_ACCEPT',
  /// // buttonDeclineText: 'QR_PERMISSION_DECLINE',
  /// // permanentlyDeniedMessage: 'QR_PERMISSION_PERMANENTLY_DENIED',
  /// ```
  PermissionData.fromName(
    this.permission, {
    @required String name,
    this.icon,
  })  : title = '${name.toUpperCase()}_PERMISSION_TITLE',
        subtitle = '${name.toUpperCase()}_PERMISSION_SUBTITLE',
        buttonAcceptText = '${name.toUpperCase()}_PERMISSION_ACCEPT',
        buttonDeclineText = '${name.toUpperCase()}_PERMISSION_DECLINE',
        permanentlyDeniedMessage =
            '${name.toUpperCase()}_PERMISSION_PERMANENTLY_DENIED';

  Future<bool> isGranted() {
    return permission.isGranted;
  }

  Future<PermissionStatus> status() {
    return permission.status;
  }

  Future<PermissionStatus> request() {
    return permission.request();
  }

  bool matches(PermissionData provider) {
    return permission == provider.permission;
  }
}
