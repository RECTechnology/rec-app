import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Components/Layout/ScrollableListLayout.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Helpers/RecNavigation.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class UserSecurityPage extends StatelessWidget {
  Widget _pinTile(BuildContext context) {
    var userState = UserState.of(context);
    var theme = Theme.of(context);

    var hasPin = userState.user.hasPin;
    var title = hasPin ? 'SETTINGS_CHANGE_PIN' : 'SETTINGS_CREATE_PIN';
    var subtitle =
        hasPin ? 'SETTINGS_CHANGE_PIN_DESC' : 'SETTINGS_CREATE_PIN_DESC';
    var route =
        hasPin ? Routes.settingsUserChangePin : Routes.settingsUserCreatePin;

    return GeneralSettingsTile(
      title: title,
      subtitle: subtitle,
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

  Widget _passwordTile(BuildContext context) {
    var theme = Theme.of(context);

    return GeneralSettingsTile(
      title: 'CHANGE_PASSWORD',
      subtitle: 'CHANGE_PASSWORD',
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
    return ScrollableListLayout.separated(
      appBar: EmptyAppBar(context, title: 'SETTINGS_USER_SECURITY'),
      children: [
        _pinTile(context),
        _passwordTile(context),
      ],
    );
  }
}
