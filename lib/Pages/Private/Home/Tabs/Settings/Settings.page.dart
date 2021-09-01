import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Components/Layout/ScrollableListLayout.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/ListTiles/SettingsListTile.dart';
import 'package:rec/Entities/Level.ent.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecNavigation.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/DocumentsProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  DocumentsProvider documentsProvider;

  @override
  void didChangeDependencies() {
    if (documentsProvider == null) {
      documentsProvider = DocumentsProvider.of(context);
      documentsProvider.load();
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
    var hasNotLoadedDocuments =
        documentsProvider == null || documentsProvider.isLoading && documentsProvider.allDocuments.isEmpty;

    if (hasNotLoadedDocuments) {
      return Center(child: CircularProgressIndicator());
    }

    var userState = UserState.of(context);
    var isCompany = userState.account.isCompany();
    var hasPin = userState.user.hasPin;
    var showDocumentsBadge = _shouldShowDocumentsBadge();

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: ScrollableListLayout(
        children: [
          SectionTitleTile('SETTINGS_USER'),
          SettingsListTile(
            title: 'SETTINGS_USER_PROFILE',
            icon: Icons.person,
            onTap: RecNavigation.getNavigateToRouteCallback(
              context,
              Routes.settingsUserProfile,
            ),
          ),
          SettingsListTile(
            title: 'SETTINGS_USER_LIMITS',
            icon: Icons.badge,
            subtitle: !showDocumentsBadge ? null : 'DOCS_REQUIRED',
            requiresActions: showDocumentsBadge,
            onTap: RecNavigation.getNavigateToRouteCallback(
              context,
              Routes.settingsUserDocuments,
            ),
          ),
          SettingsListTile(
            title: 'SETTINGS_USER_SECURITY',
            icon: Icons.lock,
            subtitle: hasPin ? null : 'PIN_REQUIRED',
            requiresActions: !hasPin,
            onTap: RecNavigation.getNavigateToRouteCallback(
              context,
              Routes.settingsUserSecurity,
            ),
          ),
          SettingsListTile(
            title: 'GENERAL_SETTINGS',
            icon: Icons.settings,
            onTap: RecNavigation.getNavigateToRouteCallback(
              context,
              Routes.settingsUserGeneral,
            ),
          ),
          SectionTitleTile('SETTINGS_ACCOUNT'),
          SettingsListTile(
            title: isCompany ? 'SETTINGS_BUSSINESS_ON_MAP' : 'SETTINGS_YOUR_ACCOUNT',
            icon: isCompany ? Icons.storefront : Icons.account_circle,
            onTap: RecNavigation.getNavigateToRouteCallback(
              context,
              isCompany ? Routes.settingsBussinessAccount : Routes.settingsYourAccount,
            ),
          ),
          SettingsListTile(
            title: 'SETTINGS_ACCOUNT_PERMISSIONS',
            icon: Icons.supervised_user_circle,
            onTap: RecNavigation.getNavigateToRouteCallback(
              context,
              Routes.settingsAccountPermissions,
            ),
          ),
          SectionTitleTile('SETTINGS_OTHER'),
          SettingsListTile(
            title: 'SETTINGS_HOW_CAN_WE_HELP',
            icon: Icons.support,
            onTap: RecNavigation.getNavigateToRouteCallback(
              context,
              Routes.settingsHelp,
            ),
          ),
          SettingsListTile(
            title: 'SETTINGS_LOGOUT',
            icon: Icons.logout,
            onTap: _logout,
          ),
          const SizedBox(
            height: 16,
          ),
          _version(),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  bool _shouldShowDocumentsBadge() {
    var userState = UserState.of(context);
    var isKyc2 = userState.user.anyAccountAtLevel(Level.CODE_KYC2);
    var hasRequiredDocs = Checks.isNotEmpty(
      documentsProvider.requiredDocuments,
    );

    return hasRequiredDocs && !isKyc2;
  }

  Widget _version() {
    var appState = AppState.of(context);
    var localizations = AppLocalizations.of(context);

    return ListTile(
      title: Text(
        localizations.translate('VERSION') + ' ' + appState.version,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Brand.primaryColor,
        ),
      ),
    );
  }

  void _logout() async {
    await Loading.show();
    await Auth.logout(context);
    await Loading.dismiss();
    await Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.login,
      ModalRoute.withName(Routes.login),
    );
  }
}
