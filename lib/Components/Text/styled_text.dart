import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/styles/styled_text_tags.dart';
import 'package:styled_text/styled_text.dart';

class LocalizedStyledText extends StatelessWidget {
  final String text;
  final Map<String, StyledTextTagBase> tags;
  final Map<String, dynamic> params;
  final TextStyle? style;
  final TextAlign? textAlign;

  const LocalizedStyledText(
    this.text, {
    Key? key,
    this.tags = const {},
    this.style,
    this.textAlign,
    this.params = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final recTheme = RecTheme.of(context);

    return StyledText(
      style: style,
      text: localizations?.translate(text, params: params) ?? text,
      textAlign: textAlign,
      tags: {
        ...tags,
        ...getDefaultTags(recTheme!),
      },
    );
  }
}
