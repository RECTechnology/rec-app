import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Helpers/RecNavigation.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class UserSecurityPage extends StatefulWidget {
  UserSecurityPage({Key key}) : super(key: key);

  @override
  _UserSecurityPageState createState() => _UserSecurityPageState();
}

class _UserSecurityPageState extends State<UserSecurityPage> {
  Widget _pinTile() {
    var userState = UserState.of(context);
    var localization = AppLocalizations.of(context);
    var theme = Theme.of(context);

    var hasPin = userState.user.hasPin;
    var title = hasPin ? 'SETTINGS_CHANGE_PIN' : 'SETTINGS_CREATE_PIN';
    var subtitle =
        hasPin ? 'SETTINGS_CHANGE_PIN_DESC' : 'SETTINGS_CREATE_PIN_DESC';

    var route =
        hasPin ? Routes.settingsUserChangePin : Routes.settingsUserCreatePin;

    return GeneralSettingsTile(
      title: localization.translate(title),
      subtitle: localization.translate(subtitle),
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      subtitleStyle: theme.textTheme.bodyText2.copyWith(
        color: Brand.grayDark4,
      ),
      onTap: RecNavigation.getNavigateToRouteCallback(context, route),
      requiresActions: !hasPin,
    );
  }

  Widget _passwordTile() {
    var localization = AppLocalizations.of(context);
    var theme = Theme.of(context);

    return GeneralSettingsTile(
      title: localization.translate('CHANGE_PASSWORD'),
      subtitle: localization.translate('CHANGE_PASSWORD'),
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      subtitleStyle: theme.textTheme.bodyText2.copyWith(
        color: Brand.grayDark4,
      ),
      onTap: RecNavigation.getNavigateToRouteCallback(
        context,
        Routes.settingsUserPassword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var tiles = [
      _pinTile(),
      _passwordTile(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(
        context,
        title: 'SETTINGS_USER_SECURITY',
      ),
      body: Scrollbar(
        thickness: 8,
        showTrackOnHover: true,
        radius: Radius.circular(3),
        child: ListView.separated(
          itemCount: tiles.length,
          itemBuilder: (BuildContext context, int index) {
            return tiles[index];
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(),
            );
          },
        ),
      ),
    );
  }
}
