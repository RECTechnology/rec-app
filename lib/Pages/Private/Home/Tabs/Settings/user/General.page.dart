import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Components/Layout/ScrollableListLayout.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/config/routes.dart';

class GeneralSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);

    return ScrollableListLayout(
      appBar: EmptyAppBar(context, title: 'GENERAL_SETTINGS'),
      children: [
        GeneralSettingsTile(
          title: localization!.getLocaleNameByLocaleId(
            localization.locale.languageCode,
          ),
          subtitle: localization.translate('MAIN_LANGUAGE'),
          onTap: RecNavigation.getNavigateToRouteCallback(
            context,
            Routes.settingsUserLanguage,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
