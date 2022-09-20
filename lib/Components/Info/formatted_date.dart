import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/Strings.dart';
import 'package:rec/providers/AppLocalizations.dart';

class FormattedDate extends StatelessWidget {
  final DateFormat? formatter;
  final DateTime date;
  final TextStyle? style;

  const FormattedDate({
    Key? key,
    this.formatter,
    required this.date,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final localizations = AppLocalizations.of(context);
    final dateString =
        (formatter ?? DateFormat('EEEE,', localizations!.locale.languageCode).add_yMMMd().add_Hm())
            .format(date.toLocal());

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          Strings.capitalizeWords(dateString),
          style: TextStyle(
            color: recTheme!.grayDark3,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ).merge(style),
        ),
      ),
    );
  }
}
