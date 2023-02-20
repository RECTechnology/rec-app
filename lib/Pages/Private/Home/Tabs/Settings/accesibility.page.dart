import 'package:flutter/material.dart';
import 'package:rec/Components/Layout/ScrollableListLayout.dart';
import 'package:rec/Components/ListTiles/SettingsListTile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/providers/app_localizations.dart';

class AccesibilityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableListLayout(
      appBar: EmptyAppBar(context, title: 'SETTINGS_ACCESIBILITY'),
      children: [
        SettingsListTile(
          title: 'COMERCE_LIST',
          icon: Icons.launch,
          onTap: () => _openHelpLink('link_comerce_list', context),
        ),
        SettingsListTile(
          title: 'ACCESIBILITY_DECLARATION',
          icon: Icons.launch,
          onTap: () => _openHelpLink('link_accesibility_declaration', context),
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
