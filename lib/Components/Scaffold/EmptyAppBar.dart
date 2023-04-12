import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';

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
  bool centerTitle = false,
}) {
  final recTheme = RecTheme.of(context);
  final titleWidget = titleText ??
      (title != null
          ? LocalizedText(
              title,
              style: TextStyle(color: recTheme!.grayDark),
            )
          : null);
  final leadingIcon = backArrow
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
    centerTitle: centerTitle,
    automaticallyImplyLeading: backArrow,
  );
}
