import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/Inputs/RoleSelector.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AccountPermissionTile extends StatefulWidget {
  final AccountPermission permission;
  final Function? onDelete;
  final ValueChangedDynamic<String>? onChangeRole;

  AccountPermissionTile(
    this.permission, {
    Key? key,
    this.onDelete,
    this.onChangeRole,
  }) : super(key: key);

  @override
  _AccountPermissionTileState createState() => _AccountPermissionTileState();
}

class _AccountPermissionTileState extends State<AccountPermissionTile> {
  @override
  Widget build(BuildContext context) {
    var permission = widget.permission;
    var userState = UserState.of(context);
    var isSameUser = userState.user!.id == permission.id.toString();

    return ListTile(
      leading: CircleAvatarRec(
        imageUrl: permission.profileImage,
        name: permission.username,
      ),
      title: Text(
        permission.username!,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: RoleSelector(
        role: permission.roles != null ? permission.roles![0] : null,
        decoration: BoxDecoration(),
        padding: EdgeInsets.only(right: 8, top: 8, bottom: 0),
        onChanged: isSameUser ? null : widget.onChangeRole,
      ),
      trailing: isSameUser
          ? null
          : IconButton(
              icon: Icon(Icons.delete),
              onPressed: widget.onDelete as void Function()?,
            ),
    );
  }
}
