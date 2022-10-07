import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/extensions/config_settings_app_extension.dart';
import 'package:rec/providers/app_provider.dart';

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
    final localizations = AppLocalizations.of(context);
    final recTheme = RecTheme.of(context);
    final config = AppProvider.of(context).configurationSettings;

    return BottomNavigationBar(
      iconSize: 22,
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: localizations!.translate('MAP'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: localizations.translate('WALLET'),
        ),
        if (config?.c2bEnabled == true)
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: localizations.translate('TAKE_PART'),
          ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: localizations.translate('SETTINGS'),
        ),
      ],
      currentIndex: currentTabIndex!,
      selectedItemColor: recTheme!.primaryColor,
      onTap: onTabTap,
    );
  }
}
