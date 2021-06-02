import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';

import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/GeneralSettings/Idiom.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/GeneralSettings/PrincipalAccount.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/UserProfile/ChangeEmail/ChangeEmail.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var localization = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(context, title: 'SETTINGS_USER_PROFILE'),
      body: Scrollbar(
        thickness: 8,
        showTrackOnHover: true,
        radius: Radius.circular(3),
        child: ListView(
          children: [
            GeneralSettingsTile(
              title: userState.user.username,
              subtitle: localization.translate('DNI_NIE'),
              textStyle: TextStyle(
                color: Brand.grayDisabled,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              subtitleTextStyle: TextStyle(
                color: Brand.grayDisabled,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            GeneralSettingsTile(
              title: '(+${userState.user.prefix.toString()}) ' +
                  userState.user.phone.toString(),
              subtitle: localization.translate('TELEFONO'),
              textStyle: TextStyle(
                  color: Brand.grayDisabled,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              subtitleTextStyle: TextStyle(
                  color: Brand.grayDisabled,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
            GeneralSettingsTile(
              title: localization.translate('EMAIL_ONLY'),
              subtitle: localization.translate('CHANGE_EMAIL'),
              textStyle: TextStyle(
                  color: Brand.detailsTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              subtitleTextStyle: TextStyle(
                  color: Brand.grayDark4,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ChangeEmail(),
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
