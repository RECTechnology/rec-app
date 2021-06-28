import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Helpers/RecNavigation.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class GeneralSettingsPage extends StatefulWidget {
  GeneralSettingsPage({Key key}) : super(key: key);

  @override
  _GeneralSettingsPageState createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Brand.defaultAvatarBackground,
      appBar: EmptyAppBar(context, title: 'GENERAL_SETTINGS'),
      body: Scrollbar(
        thickness: 8,
        showTrackOnHover: true,
        radius: Radius.circular(3),
        child: ListView(
          children: [
            // GeneralSettingsTile(
            //   title: userState.account.name,
            //   subtitle: localization.translate('PRINCIPAL_ACCOUNT'),
            //   onTap: RecNavigation.getNavigateToRouteCallback(
            //     context,
            //     Routes.settingsUserMainAccount,
            //   ),
            // ),
            GeneralSettingsTile(
              title: localization.getNameByLocaleId(
                localization.locale.languageCode,
              ),
              subtitle: localization.translate('MAIN_IDIOM'),
              onTap: RecNavigation.getNavigateToRouteCallback(
                context,
                Routes.settingsUserGeneralLanguage,
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
