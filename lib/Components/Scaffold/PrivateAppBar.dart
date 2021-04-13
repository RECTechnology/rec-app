import 'package:flutter/material.dart';
import 'package:rec/Components/CircleAvatar.dart';
import 'package:rec/Components/Modals/AccountSelectorModal.dart';
import 'package:rec/Providers/UserState.dart';

import 'package:rec/brand.dart';

class PrivateAppBar extends StatefulWidget with PreferredSizeWidget {
  final Widget bottom;
  final int size;

  const PrivateAppBar({Key key, this.bottom, this.size = 80}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PrivateAppBar();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + size);
}

class _PrivateAppBar extends State<PrivateAppBar> {
  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var account = userState.user.selectedAccount;
    var accountSelector = AccountSelectorModal(context);

    return AppBar(
      toolbarHeight: kToolbarHeight,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Brand.getGradientForAccount(account),
        ),
      ),
      elevation: 0,
      // This (using InkWell) is a bit weird
      // I could not find a better way of implementing opening the menu from the app bar, unless adding InkWell to each part
      leading: InkWell(
        onTap: accountSelector.open,
        child: Container(
          alignment: Alignment.center,
          child: CircleAvatarRec(
            imageUrl: account.publicImage,
            name: account.name,
          ),
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
      bottom: widget.bottom,
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
