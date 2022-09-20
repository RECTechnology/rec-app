import 'package:flutter/material.dart';
import 'package:rec/Components/Layout/ScrollableListLayout.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/routes.dart';

class UserSecurityPage extends StatelessWidget {
  Widget _pinTile(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final userState = UserState.of(context);
    final theme = Theme.of(context);

    final hasPin = userState.user!.hasPin!;
    final title = hasPin ? 'SETTINGS_CHANGE_PIN' : 'SETTINGS_CREATE_PIN';
    final subtitle = hasPin ? 'SETTINGS_CHANGE_PIN_DESC' : 'SETTINGS_CREATE_PIN_DESC';
    final route = hasPin ? Routes.settingsUserChangePin : Routes.settingsUserCreatePin;

    return GeneralSettingsTile(
      title: title,
      subtitle: subtitle,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      subtitleStyle: theme.textTheme.bodyText2!.copyWith(
        color: recTheme!.grayDark3,
      ),
      onTap: RecNavigation.getNavigateToRouteCallback(context, route),
      requiresActions: !hasPin,
    );
  }

  Widget _passwordTile(BuildContext context) {
    final theme = Theme.of(context);
    final recTheme = RecTheme.of(context);

    return GeneralSettingsTile(
      title: 'CHANGE_PASSWORD',
      subtitle: 'CHANGE_PASSWORD',
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      subtitleStyle: theme.textTheme.bodyText2!.copyWith(
        color: recTheme!.grayDark3,
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
