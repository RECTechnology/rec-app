import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/ListTiles/SettingsListTile.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/config/routes.dart';

class OtherSettingsList extends StatelessWidget {
  const OtherSettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitleTile('SETTINGS_OTHER'),
        SettingsListTile(
          title: 'SETTINGS_HOW_CAN_WE_HELP',
          icon: Icons.support,
          onTap: RecNavigation.getNavigateToRouteCallback(
            context,
            Routes.settingsHelp,
          ),
        ),
      ],
    );
  }
}
