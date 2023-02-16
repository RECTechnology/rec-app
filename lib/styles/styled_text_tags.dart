import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';
import 'package:styled_text/styled_text.dart';

boldTag(RecThemeData theme) => StyledTextTag(
      style: TextStyle(
        fontWeight: FontWeight.bold,
        // color: theme.grayDark,
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

internalLink(RecThemeData theme, BuildContext context) => StyledTextActionTag(
      (_, attrs) => _openLink(context, attrs),
      style: TextStyle(decoration: TextDecoration.underline, color: theme.primaryColor),
    );

_openLink(BuildContext context, attrs) {
  return Navigator.of(context).pushNamed(attrs['route']);
}

getDefaultTags(RecThemeData theme, BuildContext context) {
  return {
    'bold': boldTag(theme),
    'semibold': semiboldTag(theme),
    'primary': primaryTag(theme),
    'secondary': secondaryTag(theme),
    'green': greenTag(theme),
    'red': redTag(theme),
    'ilink': internalLink(theme, context),
  };
}
