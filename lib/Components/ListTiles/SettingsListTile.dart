import 'package:flutter/material.dart';
import 'package:rec/Components/Indicators/Badge.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class SettingsListTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  final Function onTap;

  final bool requiresActions;

  SettingsListTile({
    Key key,
    @required this.title,
    this.icon,
    this.subtitle,
    this.onTap,
    this.requiresActions = false,
  }) : super(key: key);

  @override
  _SettingsListTileState createState() => _SettingsListTileState();
}

class _SettingsListTileState extends State<SettingsListTile> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var theme = Theme.of(context);

    return Container(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: widget.onTap,
          child: ListTile(
            leading: Icon(widget.icon),
            enableFeedback: true,
            title: Text(
              localizations.translate(widget.title),
              style: theme.textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.w500,
                color: Brand.grayDark,
              ),
            ),
            subtitle: widget.subtitle != null
                ? Text(
                    localizations.translate(widget.subtitle),
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
