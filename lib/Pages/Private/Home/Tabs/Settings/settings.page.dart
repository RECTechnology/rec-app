import 'package:flutter/material.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Components/Layout/ScrollableListLayout.dart';
import 'package:rec/Components/ListTiles/SettingsListTile.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/account_settings_list.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/campaigns/campaigns_settings_list.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/other/other_settings_list.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/user_settings_list.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/app_provider.dart';
import 'package:rec/providers/documents_provider.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/config/routes.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  DocumentsProvider? documentsProvider;

  @override
  void didChangeDependencies() {
    if (documentsProvider == null) {
      documentsProvider = DocumentsProvider.of(context);
      documentsProvider!.load();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    documentsProvider = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hasNotLoadedDocuments = documentsProvider == null || documentsProvider!.isLoading;

    if (hasNotLoadedDocuments) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: ScrollableListLayout(
        children: [
          CampaignsSettingsList(),
          UserSettingsList(),
          AccountSettingsList(),
          OtherSettingsList(),
          SettingsListTile(
            title: 'SETTINGS_LOGOUT',
            icon: Icons.logout,
            onTap: _logout,
          ),
          const SizedBox(height: 16),
          _version(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _version() {
    var appState = AppProvider.of(context);
    var localizations = AppLocalizations.of(context);

    return ListTile(
      title: Text(
        localizations!.translate('VERSION') + ' ' + appState.version + '-' + appState.buildNumber,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Brand.primaryColor,
        ),
      ),
    );
  }

  void _logout() async {
    await Loading.show();
    await RecAuth.logout(context);
    await Loading.dismiss();
    await Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.login,
      ModalRoute.withName(Routes.login),
    );
  }
}
