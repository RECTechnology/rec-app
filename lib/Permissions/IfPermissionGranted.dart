import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rec/Permissions/RequestPermission.dart';
import 'package:rec/Permissions/PermissionProvider.dart';

/// Shows [widget] if permission is granted, otherwise it shows [RequestPermission] screen
/// for a specific [PermissionProvider]
///
/// You can check the docs at the [Permissions Wiki](https://github.com/QbitArtifacts/rec_app_v2/wiki/Permissions-Documentation)
class IfPermissionGranted extends StatefulWidget {
  final Widget child;
  final PermissionProvider permission;

  const IfPermissionGranted({
    Key key,
    this.permission,
    this.child,
  }) : super(key: key);

  @override
  _IfPermissionGranted createState() => _IfPermissionGranted();
}

class _IfPermissionGranted extends State<IfPermissionGranted> {
  bool granted;

  void _checkPermission() {
    // This is here to allow tests to always allow permissions
    // I don't think it is the best way, but havent been able to find another solution
    // ignore: unrelated_type_equality_checks
    if (Platform.environment['FLUTTER_TEST'] == 'true') {
      setState(() => granted = true);
      return;
    }

    widget.permission.isGranted().then((isGranted) {
      setState(() => granted = isGranted);
    });
  }

  @override
  void initState() {
    _checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (granted == null) return Center(child: CircularProgressIndicator());
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: granted
          ? widget.child
          : RequestPermission(
              permission: widget.permission,
              onAccept: _checkPermission,
              onDecline: () => Navigator.pop(context),
            ),
    );
  }
}
