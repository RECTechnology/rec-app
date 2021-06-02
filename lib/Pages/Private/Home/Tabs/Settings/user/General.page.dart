import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/GeneralSettings/Idiom.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/GeneralSettings/PrincipalAccount.page.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class GeneralSettingsPage extends StatefulWidget {
  GeneralSettingsPage({Key key}) : super(key: key);

  @override
  _GeneralSettingsPageState createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var localization = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Brand.defaultAvatarBackground,
      appBar: EmptyAppBar(context, title: 'SETTINGS_USER_GENERAL'),
      body: Scrollbar(
        thickness: 8,
        showTrackOnHover: true,
        radius: Radius.circular(3),
        child: ListView(
          children: [
            GeneralSettingsTile(
              title: userState.account.name,
              subtitle: localization.translate('PRINCIPAL_ACCOUNT'),
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => PrincipalAccountPage(),
                ));
              },
            ),
            GeneralSettingsTile(
              title: localization
                  .getNameByLocaleId(localization.locale.languageCode),
              subtitle: localization.translate('MAIN_IDIOM'),
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => IdiomPage(),
                ));
              },
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
