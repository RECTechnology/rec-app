import 'package:flutter/material.dart';
import 'package:rec/Components/CircleAvatar.dart';
import 'package:rec/Components/Modals/AccountSelectorModal.dart';
import 'package:rec/Providers/UserState.dart';

import 'package:rec/brand.dart';

class PrivateAppBar extends StatefulWidget with PreferredSizeWidget {
  final Widget bottom;
  final int size;
  final bool hasBackArrow;
  final bool selectAccountEnabled;

  const PrivateAppBar({
    Key key,
    this.bottom,
    this.size = 80,
    this.hasBackArrow = false,
    this.selectAccountEnabled = true,
  }) : super(key: key);

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

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: InkWell(
        onTap: widget.selectAccountEnabled ? accountSelector.open : null,
        child: AppBar(
          toolbarHeight: kToolbarHeight,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: Brand.getGradientForAccount(account),
            ),
          ),
          elevation: 0,
          leading: widget.hasBackArrow
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : Container(
                  alignment: Alignment.center,
                  child: CircleAvatarRec.fromAccount(account),
                ),
          title: Center(
            child: Text(
              userState.user.selectedAccount.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
            ),
          ),
          bottom: widget.bottom,
          actions: [
            widget.selectAccountEnabled
                ? Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 65,
                    child: Icon(Icons.arrow_drop_down_sharp),
                  )
                : SizedBox(height: 45, width: 65),
          ],
        ),
      ),
    );
  }
}
