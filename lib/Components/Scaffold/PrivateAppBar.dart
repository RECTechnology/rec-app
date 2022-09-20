import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/Modals/AccountSelectorModal.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/styles/box_decorations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class PrivateAppBar extends StatefulWidget with PreferredSizeWidget {
  final Widget? bottom;
  final int size;
  final bool hasBackArrow;
  final bool selectAccountEnabled;
  final Color? backgroundColor;
  final Color? color;
  final String? title;
  final TextAlign textAlign;
  final Alignment alignment;

  const PrivateAppBar({
    Key? key,
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
    final userState = UserState.of(context);
    final recTheme = RecTheme.of(context);
    final account = userState.user!.selectedAccount;
    final accountSelector = AccountSelectorModal(context);
    final flexibleSpace = Container(
      decoration: widget.backgroundColor != null
          ? BoxDecorations.solid(widget.backgroundColor!)
          : BoxDecorations.gradient(
              recTheme!.accountTypeGradient(account!.type ?? Account.TYPE_PRIVATE)),
    );
    final appBar = AppBar(
      backgroundColor: widget.backgroundColor,
      flexibleSpace: widget.bottom == null ? null : flexibleSpace,
      elevation: 0,
      bottom: widget.bottom as PreferredSizeWidget?,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: (widget.selectAccountEnabled) ? accountSelector.open : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.hasBackArrow
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(right: 8, left: 0),
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
                    child: CircleAvatarRec.fromAccount(account!),
                  ),
            Flexible(
              child: LocalizedText(
                (widget.title ?? userState.user!.selectedAccount!.name) ?? '',
                textAlign: widget.textAlign,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: widget.color ?? Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
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
                : SizedBox.shrink()
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
