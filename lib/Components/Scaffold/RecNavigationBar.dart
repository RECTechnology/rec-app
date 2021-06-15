import 'package:flutter/material.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class RecNavigationBar extends StatefulWidget {
  final int currentTabIndex;
  final Function(int index) onTabTap;

  RecNavigationBar({
    Key key,
    this.currentTabIndex,
    this.onTabTap,
  }) : super(key: key);

  @override
  _RecNavigationBarState createState() => _RecNavigationBarState();
}

class _RecNavigationBarState extends State<RecNavigationBar> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var userState = UserState.of(context);
    var isLtabAccount = userState.account.isLtabAccount();

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: localizations.translate('MAP'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: localizations.translate('WALLET'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: localizations.translate('SETTINGS'),
        ),
      ],
      currentIndex: widget.currentTabIndex,
      selectedItemColor: Brand.primaryColor,
      onTap: (int index) {
        // HACK: Disable settings if account is ltab
        // Need to look for some way of disabling tabs,
        // as they are somewhat custom
        if (isLtabAccount && index == 2) {
          RecToast.showInfo(context, 'SETTINGS_NOT_AVAILABLE');
          return;
        }

        widget.onTabTap(index);
      },
    );
  }
}
