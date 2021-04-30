import 'package:flutter/material.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

Widget EmptyAppBar(
  BuildContext context, {
  bool backArrow = true,
  String title,
  Text titleText,
}) {
  var localizations = AppLocalizations.of(context);
  var titleWidget = titleText ??
      (title != null
          ? Text(
              localizations.translate(title),
              style: TextStyle(color: Brand.grayDark),
            )
          : null);
  var leadingIcon = backArrow
      ? IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      : null;

  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: titleWidget,
    leading: leadingIcon,
  );
}
