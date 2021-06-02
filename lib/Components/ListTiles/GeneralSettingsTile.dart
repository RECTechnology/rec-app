import 'package:flutter/material.dart';
import 'package:rec/Components/Indicators/Badge.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class GeneralSettingsTile extends StatefulWidget {
  final String title;
  final CircleAvatarRec circleAvatar;
  final String subtitle;
  final Function onTap;
  final TextStyle textStyle;
  final TextStyle subtitleTextStyle;
  final Icon icon;
  final bool requiresActions;

  GeneralSettingsTile({
    Key key,
    @required this.title,
    this.circleAvatar,
    this.subtitle,
    this.textStyle,
    this.subtitleTextStyle,
    this.onTap,
    this.icon,
    this.requiresActions = false,
  }) : super(key: key);

  @override
  _GeneralSettingsTileState createState() => _GeneralSettingsTileState();
}

class _GeneralSettingsTileState extends State<GeneralSettingsTile> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var theme = Theme.of(context);

    return Container(
      color: Colors.white,
      child: Row(
        children: [
          widget.circleAvatar != null
              ? Padding(
                  padding: EdgeInsets.only(left: 32, right: 16),
                  child: widget.circleAvatar,
                )
              : Container(),
          Expanded(
            child: InkWell(
              onTap: widget.onTap,
              child: ListTile(
                title: Text(
                  localizations.translate(widget.title),
                  style: widget.textStyle ?? theme.textTheme.subtitle1,
                ),
                subtitle: widget.subtitle != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          localizations.translate(widget.subtitle),
                          style: widget.subtitleTextStyle ??
                              theme.textTheme.caption.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Brand.graySubtitle,
                              ),
                        ),
                      )
                    : null,
                trailing: widget.requiresActions ? RecBadge() : null,
              ),
            ),
          ),
          widget.icon != null
              ? Padding(
                  padding: EdgeInsets.only(
                    right: 16,
                  ),
                  child: Container(
                    width: 20,
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: widget.icon,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
