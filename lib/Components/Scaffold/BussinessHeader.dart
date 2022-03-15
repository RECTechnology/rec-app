import 'package:flutter/material.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/brand.dart';
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
                        Container(
                          padding: EdgeInsets.only(bottom: 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.account!.name ?? 'Text not found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Brand.grayDark,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        widget.subtitle ??
                            LocalizedText(
                              widget.account!.addressString!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Brand.grayDark,
                                fontWeight: FontWeight.w300,
                              ),
                              overflow: TextOverflow.ellipsis,
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
