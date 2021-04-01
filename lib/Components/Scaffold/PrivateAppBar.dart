import 'package:flutter/material.dart';
import 'package:rec/Components/CircleAvatar.dart';
import 'package:rec/Components/Scaffold/AppBarMenu.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class PrivateAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var account = userState.user.selectedAccount;
    return Container(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CircleAvatarRec(
              imageUrl: account.publicImage,
            ),
          ),
          Text(userState.user.selectedAccount.name)
        ],
      ),
    );
  }

  static AppBar getAppBar(BuildContext context, {PreferredSizeWidget bottom}) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Brand.appBarGradient,
        ),
      ),
      title: PrivateAppBar(),
      bottom: bottom,
      actions: [
        AppBarMenu(),
      ],
    );
  }
}
