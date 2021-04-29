import 'package:flutter/material.dart';
import 'package:rec/Components/RequestPermission.dart';
import 'package:rec/Permissions/PermissionProvider.dart';

class AskForPermission extends StatefulWidget {
  final Function() onAccept;
  final Function() onDecline;
  final PermissionProvider permission;

  const AskForPermission({
    Key key,
    @required this.permission,
    this.onAccept,
    this.onDecline,
  }) : super(key: key);

  @override
  _AskForPermission createState() => _AskForPermission();
}

class _AskForPermission extends State<AskForPermission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RequestPermission(
        permission: widget.permission,
        onAccept: widget.onAccept,
        onDecline: widget.onDecline,
      ),
    );
  }
}
