import 'package:flutter/material.dart';
import 'package:rec/Components/Layout/ScrollableListLayout.dart';
import 'package:rec/Components/ListTiles/SettingsListTile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/providers/app_localizations.dart';
import '../../../../../config/routes.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableListLayout(
      appBar: EmptyAppBar(context, title: 'SETTINGS_HOW_CAN_WE_HELP'),
      children: [
        SettingsListTile(
          title: 'SETTINGS_HELP_ABOUT',
          icon: Icons.group,
          onTap: () => _openHelpLink('link_about', context),
        ),
        SettingsListTile(
          title: 'SETTINGS_HELP_FAQ',
          icon: Icons.support,
          onTap: () => _openHelpLink('link_faqs', context),
        ),
        SettingsListTile(
          title: 'SETTINGS_HELP_SUPPORT',
          icon: Icons.headset_mic,
          onTap: () => _openHelpLink('link_contact', context),
        ),
        SettingsListTile(
          title: 'SETTINGS_HELP_TOS',
          icon: Icons.description,
          onTap: () => _openHelpLink('link_tos', context),
        ),
        SettingsListTile(
          title: 'SETTINGS_ACCESIBILITY',
          icon: Icons.accessibility,
          onTap: RecNavigation.getNavigateToRouteCallback(
            context,
            Routes.settingsAccesibility,
          ),
        ),
        SettingsListTile(
          title: 'DELETE_MY_USER',
          icon: Icons.group_off,
          onTap: RecNavigation.getNavigateToRouteCallback(
            context,
            Routes.settingsDeleteAccount,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _openHelpLink(String label, context) {
    var localizations = AppLocalizations.of(context);

    InAppBrowser.openLink(
      context,
      localizations!.translate(label),
      title: localizations.translate('title.$label'),
    );
  }
}
