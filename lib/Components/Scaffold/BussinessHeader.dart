import 'package:flutter/material.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class BussinessHeader extends StatefulWidget with PreferredSizeWidget {
  final Account account;
  final int size = 120;
  final Widget avatarBadge;
  final Widget subtitle;

  BussinessHeader(
    this.account, {
    Key key,
    this.avatarBadge,
    this.subtitle,
  }) : super(key: key);

  @override
  _BussinessHeaderState createState() => _BussinessHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(120);
}

class _BussinessHeaderState extends State<BussinessHeader> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: Stack(
        children: [
          Container(
            height: widget.preferredSize.height,
            decoration: Checks.isNotEmpty(widget.account.publicImage)
                ? BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.account.publicImage,
                      ),
                    ),
                  )
                : null,
          ),
          Container(
            height: widget.preferredSize.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white38, Colors.white],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 9, 0, 11),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: CircleAvatarRec(
                          imageUrl: widget.account.companyImage,
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
                            widget.account.name ?? 'Text not found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Brand.grayDark,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        widget.subtitle ??
                            Text(
                              localizations
                                  .translate(widget.account.addressString),
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
