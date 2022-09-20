import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AccountTypeHeader extends StatefulWidget with PreferredSizeWidget {
  final bool isPrivate;
  final ValueChanged<bool> onChanged;
  final bool hidePrivate;
  final bool hideCompany;

  AccountTypeHeader({
    Key? key,
    required this.onChanged,
    this.isPrivate = false,
    this.hidePrivate = false,
    this.hideCompany = false,
  }) : super(key: key);

  @override
  _AccountTypeHeaderState createState() => _AccountTypeHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(100);
}

class _AccountTypeHeaderState extends State<AccountTypeHeader> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recTheme = RecTheme.of(context);
    final assets = recTheme!.assets;
    final selectedTheme = theme.textTheme.bodyText1!.copyWith(
      color: recTheme.grayDark,
      fontWeight: FontWeight.w500,
    );
    final unselectedTheme = theme.textTheme.bodyText1!.copyWith(
      color: recTheme.grayDark3,
      fontWeight: FontWeight.w400,
    );

    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Container(
        height: 100,
        padding: EdgeInsets.only(left: 24, right: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!widget.hidePrivate)
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    IconButton(
                      icon: widget.isPrivate
                          ? Image.asset(assets.avatar)
                          : Image.asset(assets.avatarDisabled),
                      onPressed: () => widget.onChanged(true),
                      iconSize: 50,
                    ),
                    SizedBox(height: 8),
                    LocalizedText(
                      'PARTICULAR',
                      style: widget.isPrivate ? selectedTheme : unselectedTheme,
                    )
                  ],
                ),
              ),
            if (!widget.hideCompany)
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    IconButton(
                      icon: widget.isPrivate
                          ? Image.asset(assets.companyAvatarDisabled)
                          : Image.asset(assets.companyAvatar),
                      onPressed: () => widget.onChanged(false),
                      iconSize: 50,
                    ),
                    SizedBox(height: 8),
                    LocalizedText(
                      'ORGANIZATION',
                      style: !widget.isPrivate ? selectedTheme : unselectedTheme,
                    )
                  ],
                ),
              ),
          ].where(Checks.isNotNull).toList(),
        ),
      ),
    );
  }
}
