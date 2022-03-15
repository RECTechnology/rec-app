import 'package:flutter/material.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AccountListTile extends StatefulWidget {
  final CircleAvatarRec? avatar;
  final String? name;
  final EdgeInsets padding;
  final Function? onTap;
  final Widget? trailing;

  AccountListTile({
    Key? key,
    this.avatar,
    this.name,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 4,
    ),
    this.onTap,
    this.trailing,
  }) : super(key: key);

  AccountListTile.fromAccount(
    Account account, {
    Key? key,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 4,
    ),
    this.trailing,
  })  : avatar = CircleAvatarRec.fromAccount(account),
        name = account.name,
        super(key: key);

  @override
  _AccountListTile createState() => _AccountListTile();
}

class _AccountListTile extends State<AccountListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: ListTile(
          onTap: widget.onTap as void Function()?,
          tileColor: Colors.white,
          leading: widget.avatar,
          title: Text(widget.name!),
          trailing: widget.trailing,
        ),
      ),
    );
  }
}
