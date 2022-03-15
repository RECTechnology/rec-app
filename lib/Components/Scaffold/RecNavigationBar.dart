import 'package:flutter/material.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/config/brand.dart';

class RecNavigationBar extends StatelessWidget {
  final int? currentTabIndex;
  final Function(int index)? onTabTap;

  RecNavigationBar({
    Key? key,
    this.currentTabIndex,
    this.onTabTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: localizations!.translate('MAP'),
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
      currentIndex: currentTabIndex!,
      selectedItemColor: Brand.primaryColor,
      onTap: onTabTap,
    );
  }
}
