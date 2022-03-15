import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/ListTiles/SettingsListTile.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/providers/documents_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class UserSettingsList extends StatefulWidget {
  UserSettingsList({Key? key}) : super(key: key);

  @override
  _UserSettingsListState createState() => _UserSettingsListState();
}

class _UserSettingsListState extends State<UserSettingsList> {
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
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var hasPin = userState.user!.hasPin;
    var showDocumentsBadge = _shouldShowDocumentsBadge();

    return Column(
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
          subtitle: hasPin! ? null : 'PIN_REQUIRED',
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
      ],
    );
  }

  bool _shouldShowDocumentsBadge() {
    var userState = UserState.of(context);
    var isKyc2 = userState.user!.anyAccountAtLevel(Level.CODE_KYC2);

    return documentsProvider!.hasRequiredDocuments && !isKyc2;
  }
}
