import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class SectionTitleTile extends StatelessWidget {
  final FontWeight fontWeight;
  final String title;
  final Color? textColor;

  const SectionTitleTile(
    this.title, {
    Key? key,
    this.textColor,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final recTheme = RecTheme.of(context);
    final account = UserState.of(context).account;
    final color = recTheme!.accountTypeColor(account?.type ?? Account.TYPE_PRIVATE);

    return ListTile(
      tileColor: Colors.white,
      title: LocalizedText(
        title,
        style: textTheme.subtitle1!.copyWith(
          color: textColor ?? color,
          fontWeight: fontWeight,
          fontSize: 16,
        ),
      ),
    );
  }
}
