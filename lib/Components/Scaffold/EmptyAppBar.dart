import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/brand.dart';


// TODO: Refactor this, it's not good
AppBar EmptyAppBar(
  BuildContext context, {
  bool backArrow = true,
  bool crossX = false,
  String? title,
  Text? titleText,
  List<Widget>? actions,
  Color backgroundColor = Colors.white,
  VoidCallback? backAction,
  VoidCallback? closeAction,
}) {
  var titleWidget = titleText ??
      (title != null
          ? LocalizedText(
              title,
              style: TextStyle(color: Brand.grayDark),
            )
          : null);
  var leadingIcon = backArrow
      ? IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: backAction ??
              () {
                Navigator.of(context).pop();
              },
        )
      : crossX
          ? IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: closeAction ??
                  () {
                    Navigator.of(context).pop();
                  },
            )
          : null;

  return AppBar(
    backgroundColor: backgroundColor,
    elevation: 0,
    title: titleWidget,
    leading: leadingIcon,
    actions: actions,
    automaticallyImplyLeading: backArrow,
  );
}
