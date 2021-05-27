import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionProvider {
  Permission permission;
  IconData icon;
  String title;
  String subtitle;
  String permanentlyDeniedMessage;

  String buttonAcceptText;
  String buttonDeclineText;

  PermissionProvider(
    this.permission, {
    this.icon,
    this.title,
    this.subtitle,
    this.buttonAcceptText,
    this.buttonDeclineText,
    this.permanentlyDeniedMessage,
  });

  Future<bool> isGranted() {
    return permission.isGranted;
  }

  Future<PermissionStatus> status() {
    return permission.status;
  }

  Future<PermissionStatus> request() {
    return permission.request();
  }

  bool matches(PermissionProvider provider) {
    return permission == provider.permission;
  }
}
