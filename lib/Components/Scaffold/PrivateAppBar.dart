import 'package:flutter/material.dart';
import 'package:rec/Components/CircleAvatar.dart';
import 'package:rec/Components/Modals/AccountSelectorModal.dart';
import 'package:rec/Providers/UserState.dart';

import 'package:rec/brand.dart';

class PrivateAppBar {
  static AppBar getAppBar(BuildContext context, {PreferredSizeWidget bottom}) {
    var userState = UserState.of(context);
    var account = userState.user.selectedAccount;
    var accountSelector = AccountSelectorModal(context);

    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Brand.getGradientForAccount(account),
        ),
      ),
      elevation: 0,
      leading: Container(
        alignment: Alignment.center,
        child: CircleAvatarRec(
          imageUrl: account.publicImage,
          name: account.name,
          size: 35,
        ),
      ),
      title: InkWell(
        onTap: accountSelector.open,
        child: Center(
          child: Text(
            userState.user.selectedAccount.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w200),
          ),
        ),
      ),
      bottom: bottom,
      actions: [
        InkWell(
          onTap: accountSelector.open,
          child: Container(
            alignment: Alignment.center,
            height: 45,
            width: 65,
            child: Icon(Icons.arrow_drop_down_sharp),
          ),
        ),
      ],
    );
  }
}
