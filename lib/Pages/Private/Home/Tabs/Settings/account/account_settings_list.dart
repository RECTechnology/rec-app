import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/ListTiles/SettingsListTile.dart';
import 'package:rec/Components/conditionals/show_if_roles.dart';
import 'package:rec/config/roles_definitions.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/routes.dart';

class AccountSettingsList extends StatelessWidget {
  const AccountSettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var isCompany = userState.account!.isCompany();
    var isLtabAccount = userState.account!.isCampaignAccount(env.CMP_LTAB_CODE);
    var isCultureAccount = userState.account!.isCampaignAccount(env.CMP_CULT_CODE);
    var productsEnabled = userState.account!.productsEnabled == true;

    if (isLtabAccount || isCultureAccount) {
      return SizedBox.shrink();
    }

    return ShowIfRoles(
      validRoles: RoleDefinitions.accountSettings,
      child: Column(
        children: [
          SectionTitleTile('SETTINGS_ACCOUNT'),
          SettingsListTile(
            title: isCompany ? 'SETTINGS_BUSSINESS_ON_MAP' : 'SETTINGS_YOUR_ACCOUNT',
            icon: isCompany ? Icons.storefront : Icons.account_circle,
            onTap: RecNavigation.getNavigateToRouteCallback(
              context,
              isCompany ? Routes.settingsBussinessAccount : Routes.settingsYourAccount,
            ),
          ),
          if (isCompany)
            SettingsListTile(
              title: 'SETTINGS_CONNECTA',
              icon: Icons.swap_calls,
              onTap: RecNavigation.getNavigateToRouteCallback(
                context,
                productsEnabled ? Routes.settingsConnectaActive : Routes.settingsConnectaInactive,
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
          SettingsListTile(
            title: 'SETTINGS_DAILY_BALANCE',
            icon: Icons.timeline,
            onTap: RecNavigation.getNavigateToRouteCallback(
              context,
              Routes.settingsDaySales,
            ),
          ),
        ],
      ),
    );
  }
}
