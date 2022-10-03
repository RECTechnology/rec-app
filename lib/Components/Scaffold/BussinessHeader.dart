import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class BussinessHeader extends StatefulWidget with PreferredSizeWidget {
  final Account? account;
  final double size = 120;
  final Widget? avatarBadge;
  final Widget? subtitle;

  BussinessHeader(
    this.account, {
    Key? key,
    this.avatarBadge,
    this.subtitle,
  }) : super(key: key);

  @override
  _BussinessHeaderState createState() => _BussinessHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(size);
}

class _BussinessHeaderState extends State<BussinessHeader> {
  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: Stack(
        children: [
          Container(
            height: widget.preferredSize.height,
            decoration: BoxDecoration(
              image: Checks.isNotEmpty(widget.account!.publicImage)
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.account!.publicImage!,
                      ),
                    )
                  : null,
            ),
          ),
          Container(
            height: widget.preferredSize.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withAlpha(0),
                  Colors.white.withAlpha(255)
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 9, 24, 11),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: CircleAvatarRec(
                          imageUrl: widget.account!.companyImage,
                          name: widget.account!.name,
                          radius: 32,
                        ),
                      ),
                      widget.avatarBadge ?? SizedBox.shrink(),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 15, 0, 7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: 8,
                            ),
                            child: Text(
                              widget.account!.name ?? 'Text not found',
                              style: TextStyle(
                                fontSize: 18,
                                color: recTheme!.grayDark,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        widget.subtitle ??
                            Flexible(
                              child: Wrap(children: [
                                Icon(Icons.schedule_outlined,
                                    color: recTheme.grayDark),
                                SizedBox(width: 5),
                                Container(
                                  margin: EdgeInsets.only(top: 4),
                                  child: LocalizedText(
                                    widget.account!.schedule!
                                        .getStateNameForDate(DateTime.now()),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: recTheme.grayDark,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ]),
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
