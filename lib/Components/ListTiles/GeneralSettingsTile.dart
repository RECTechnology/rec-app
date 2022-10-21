import 'package:flutter/material.dart';
import 'package:rec/Components/Indicators/Badge.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';

class GeneralSettingsTile extends StatefulWidget {
  final String? title;
  final CircleAvatarRec? circleAvatar;
  final String? subtitle;
  final Function? onTap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Icon? icon;
  final bool requiresActions;
  final bool disabled;

  GeneralSettingsTile({
    Key? key,
    required this.title,
    this.circleAvatar,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.onTap,
    this.icon,
    this.requiresActions = false,
    this.disabled = false,
  }) : super(key: key);

  @override
  _GeneralSettingsTileState createState() => _GeneralSettingsTileState();
}

class _GeneralSettingsTileState extends State<GeneralSettingsTile> {
  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = (widget.titleStyle ?? textTheme.subtitle1)!.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: widget.disabled ? recTheme!.grayDark : null,
    );
    final subtitleStyle = (widget.subtitleStyle ?? textTheme.caption)!.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: widget.disabled ? recTheme!.grayLight3 : null,
    );

    return InkWell(
      onTap: widget.onTap as void Function()?,
      child: Container(
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
              child: ListTile(
                title: LocalizedText(
                  widget.title ?? '',
                  style: titleStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: widget.subtitle != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: LocalizedText(
                          widget.subtitle ?? '',
                          style: subtitleStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : null,
                trailing: widget.requiresActions ? RecBadge() : null,
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
      ),
    );
  }
}
