import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionProvider {
  Permission permission;
  IconData icon;
  String title;
  String subtitle;

  String buttonAcceptText;
  String buttonDeclineText;

  PermissionProvider(
    this.permission, {
    this.icon,
    this.title,
    this.subtitle,
    this.buttonAcceptText,
    this.buttonDeclineText,
  });

  Future<bool> isGranted() {
    return permission.isGranted;
  }

  Future<bool> request() {
    return permission.request().isGranted;
  }

  bool matches(PermissionProvider provider) {
    return permission == provider.permission;
  }
}
