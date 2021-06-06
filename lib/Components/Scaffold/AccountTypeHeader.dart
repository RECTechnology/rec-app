import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/brand.dart';

class AccountTypeHeader extends StatefulWidget with PreferredSizeWidget {
  final bool isPrivate;
  final ValueChanged<bool> onChanged;
  final bool hidePrivate;
  final bool hideCompany;

  AccountTypeHeader({
    Key key,
    @required this.onChanged,
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
    var theme = Theme.of(context);

    var selectedTheme = theme.textTheme.bodyText1.copyWith(
      color: Brand.grayDark,
      fontWeight: FontWeight.w500,
    );

    var unselectedTheme = theme.textTheme.bodyText1.copyWith(
      color: Brand.grayDark3,
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
                          ? Image.asset('assets/avatar.png')
                          : Image.asset('assets/avatar-bw.png'),
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
                          ? Image.asset('assets/organization-bw.png')
                          : Image.asset('assets/organization.png'),
                      onPressed: () => widget.onChanged(false),
                      iconSize: 50,
                    ),
                    SizedBox(height: 8),
                    LocalizedText(
                      'ORGANIZATION',
                      style:
                          !widget.isPrivate ? selectedTheme : unselectedTheme,
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
