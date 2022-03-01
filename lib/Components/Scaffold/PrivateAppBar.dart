import 'package:flutter/material.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Components/Modals/AccountSelectorModal.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/BoxDecorations.dart';
import 'package:rec/brand.dart';

class PrivateAppBar extends StatefulWidget with PreferredSizeWidget {
  final Widget bottom;
  final int size;
  final bool hasBackArrow;
  final bool selectAccountEnabled;
  final Color backgroundColor;
  final Color color;
  final String title;
  final TextAlign textAlign;
  final Alignment alignment;

  const PrivateAppBar({
    Key key,
    this.bottom,
    this.size = 80,
    this.hasBackArrow = false,
    this.selectAccountEnabled = true,
    this.backgroundColor,
    this.title,
    this.color,
    this.textAlign = TextAlign.center,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PrivateAppBar();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + size);
}

class _PrivateAppBar extends State<PrivateAppBar> {
  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var account = userState.user.selectedAccount;
    var accountSelector = AccountSelectorModal(context);

    var flexibleSpace = Container(
      decoration: widget.backgroundColor != null
          ? BoxDecorations.solid(widget.backgroundColor)
          : BoxDecorations.gradient(
              Brand.getGradientForAccount(account),
            ),
    );

    var appBar = AppBar(
      backgroundColor: widget.backgroundColor,
      flexibleSpace: widget.bottom == null ? null : flexibleSpace,
      elevation: 0,
      bottom: widget.bottom,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: (widget.selectAccountEnabled) ? accountSelector.open : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.hasBackArrow
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: widget.color ?? Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                : Container(
                    alignment: Alignment.center,
                    child: CircleAvatarRec.fromAccount(account),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: LocalizedText(
                widget.title ?? userState.user.selectedAccount.name,
                textAlign: widget.textAlign,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: widget.color ?? Colors.white,
                ),
              ),
            ),
            widget.selectAccountEnabled
                ? Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 65,
                    child: Icon(
                      Icons.group,
                      color: widget.color ?? Colors.white,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );

    if (widget.bottom != null) {
      return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: appBar,
      );
    }

    return appBar;
  }
}
