import 'package:flutter/material.dart';
import 'package:rec/Components/Indicators/Badge.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';

class SettingsListTile extends StatefulWidget {
  final String? title;
  final IconData? icon;
  final String? subtitle;
  final Function? onTap;
  final Widget? leading;

  final bool requiresActions;

  SettingsListTile({
    Key? key,
    required this.title,
    this.icon,
    this.subtitle,
    this.onTap,
    this.requiresActions = false,
    this.leading,
  }) : super(key: key);

  @override
  _SettingsListTileState createState() => _SettingsListTileState();
}

class _SettingsListTileState extends State<SettingsListTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recTheme = RecTheme.of(context);

    return Container(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: widget.onTap as void Function()?,
          child: ListTile(
            leading: widget.leading ?? Icon(widget.icon),
            enableFeedback: true,
            title: LocalizedText(
              widget.title!,
              style: theme.textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.w500,
                color: recTheme!.grayDark,
              ),
            ),
            subtitle: widget.subtitle != null
                ? LocalizedText(
                    widget.subtitle!,
                    style: theme.textTheme.caption,
                  )
                : null,
            trailing: widget.requiresActions ? RecBadge() : null,
          ),
        ),
      ),
    );
  }
}
