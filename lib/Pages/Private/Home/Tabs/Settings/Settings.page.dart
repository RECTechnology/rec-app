import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/ListTiles/SettingsListTile.dart';
import 'package:rec/Entities/Level.ent.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecNavigation.dart';
import 'package:rec/Pages/LtabCampaign/LtabInitialBanner.page.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/CampaignProvider.dart';
import 'package:rec/Providers/DocumentsProvider.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
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
    var hasNotLoadedDocuments = documentsProvider == null ||
        documentsProvider.isLoading && documentsProvider.allDocuments.isEmpty;

    if (hasNotLoadedDocuments) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    var activeCampaign =
        CampaignProvider.of(context, listen: false).activeCampaign;
    var userState = UserState.of(context);
    var isCompany = userState.account.isCompany();
    var hasPin = userState.user.hasPin;
    var hasRequiredDocs = Checks.isNotEmpty(
      documentsProvider.requiredDocuments,
    );
    var isKyc2 = userState.user.anyAccountAtLevel(Level.CODE_KYC2);
    var showDocumentsBadge = hasRequiredDocs && !isKyc2;

    var localizations = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: PrivateAppBar(
          backgroundColor: Colors.white,
          color: Brand.grayDark,
          size: 0,
        ),
        body: Scrollbar(
          thickness: 8,
          showTrackOnHover: true,
          radius: Radius.circular(3),
          child: ListView(
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
              SectionTitleTile('SETTINGS_ACCOUNT'),
              SettingsListTile(
                title: isCompany
                    ? 'SETTINGS_BUSSINESS_ON_MAP'
                    : 'SETTINGS_YOUR_ACCOUNT',
                icon: isCompany ? Icons.storefront : Icons.account_circle,
                onTap: RecNavigation.getNavigateToRouteCallback(
                  context,
                  isCompany
                      ? Routes.settingsBussinessAccount
                      : Routes.settingsYourAccount,
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
              SectionTitleTile('SETTINGS_HELP'),
              SettingsListTile(
                title: 'SETTINGS_HELP_ABOUT',
                icon: Icons.group,
                onTap: () {
                  InAppBrowser.openLink(
                    context,
                    localizations.translate('link_about'),
                  );
                },
              ),
              SettingsListTile(
                title: 'SETTINGS_HELP_FAQ',
                icon: Icons.support,
                onTap: () {
                  InAppBrowser.openLink(
                    context,
                    localizations.translate('link_faqs'),
                  );
                },
              ),
              SettingsListTile(
                title: 'SETTINGS_HELP_SUPPORT',
                icon: Icons.headset_mic,
                onTap: () {
                  InAppBrowser.openLink(
                    context,
                    localizations.translate('link_contact'),
                  );
                },
              ),
              SettingsListTile(
                title: 'SETTINGS_HELP_TOS',
                icon: Icons.description,
                onTap: () {
                  InAppBrowser.openLink(
                    context,
                    localizations.translate('link_tos'),
                  );
                },
              ),
              if (LtabInitialBanner.isActive(context))
                SettingsListTile(
                  title: 'LI TOCA AL BARRI',
                  leading: Container(
                    height: 24,
                    width: 24,
                    child: CircleAvatarRec(
                      imageUrl: activeCampaign.imageUrl,
                    ),
                  ),
                  onTap: _campaignLinkTapped,
                ),
              _version(),
              SettingsListTile(
                title: 'SETTINGS_LOGOUT',
                icon: Icons.logout,
                onTap: _logout,
              ),
              const SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _campaignLinkTapped() {
    var link = AppLocalizations.of(context).translate('link_ltab');
    InAppBrowser.openLink(context, link);
  }

  Widget _version() {
    var appState = AppState.of(context);
    var localizations = AppLocalizations.of(context);

    return ListTile(
      title: Text(
        localizations.translate('VERSION') + ' ' + appState.version,
        textAlign: TextAlign.center,
      ),
    );
  }

  void _logout() async {
    await Loading.show();
    await Auth.logout();

    UserState.of(context, listen: false).clear();
    TransactionProvider.of(context, listen: false).clear();

    await Loading.dismiss();
    await Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.login,
      ModalRoute.withName(Routes.login),
    );
  }
}
