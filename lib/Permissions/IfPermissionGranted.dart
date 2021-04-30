import 'package:flutter/material.dart';
import 'package:rec/Permissions/RequestPermission.dart';
import 'package:rec/Permissions/PermissionProvider.dart';

/// Shows [widget] if permission is granted, otherwise it shows [RequestPermission] screen
/// for a specific [PermissionProvider]
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
  bool granted = false;

  void _checkPermission() {
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
