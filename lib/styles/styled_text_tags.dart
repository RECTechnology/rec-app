import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';
import 'package:styled_text/styled_text.dart';

boldTag(RecThemeData theme) => StyledTextTag(
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: theme.grayDark,
      ),
    );

semiboldTag(RecThemeData theme) => StyledTextTag(
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: theme.grayDark,
      ),
    );

primaryTag(RecThemeData theme) => StyledTextTag(
      style: TextStyle(color: theme.primaryColor),
    );

secondaryTag(RecThemeData theme) => StyledTextTag(
      style: TextStyle(color: theme.accentColor),
    );

greenTag(RecThemeData theme) => StyledTextTag(
      style: TextStyle(color: theme.green2),
    );

redTag(RecThemeData theme) => StyledTextTag(
      style: TextStyle(color: theme.red),
    );

getDefaultTags(RecThemeData theme) {
  return {
    'bold': boldTag,
    'semibold': semiboldTag,
    'primary': primaryTag,
    'secondary': secondaryTag,
    'green': greenTag,
    'red': redTag,
  };
}
