import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';

/// Custom text theme class containing the text theme for the REC app
class RecTextTheme {
  final TextStyle pageTitle;
  final TextStyle outlineTileText;
  final TextStyle pageSubtitle1;
  final TextStyle link;

  RecTextTheme.fromTheme(RecThemeData theme)
      : pageTitle = TextStyle(
          fontSize: 20,
          color: theme.grayDark,
          fontWeight: FontWeight.w500,
        ),
        outlineTileText = TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        pageSubtitle1 = TextStyle(
          fontSize: 18,
          color: theme.grayDark3,
        ),
        link = TextStyle(
          color: theme.primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        );
}
