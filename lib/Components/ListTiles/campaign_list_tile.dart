import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/SettingsListTile.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CampaignsListTile extends StatelessWidget {
  final Campaign? campaign;
  final Widget? leading;
  final Function? onTap;
  final String? title;
  final String? description;

  const CampaignsListTile({
    Key? key,
    this.campaign,
    this.leading,
    this.onTap,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      title: title ?? campaign!.name,
      subtitle: description ?? campaign!.description,
      leading: leading,
      onTap: onTap,
    );
  }
}
