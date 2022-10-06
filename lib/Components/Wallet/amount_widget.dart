import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AmountWidget extends StatelessWidget {
  final double amount;
  final bool isNegative;
  final TextStyle? style;

  const AmountWidget({
    Key? key,
    required this.amount,
    this.isNegative = false,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)?.locale;
    final recTheme = RecTheme.of(context);

    final color = isNegative ? recTheme!.red : recTheme!.primaryColor;
    final amountFormatted = Currency.format(amount, locale: locale.toString());
    final amountString = isNegative ? '-$amountFormatted R' : '+$amountFormatted R';

    return Text(
      amountString,
      style: TextStyle(
        fontSize: 16,
        color: color,
        fontWeight: FontWeight.w300,
      ).merge(style),
    );
  }
}

/// Same as [AmountWidget], the only difference is that this widgets styles int and decimals differently
class FancyAmountWidget extends StatelessWidget {
  final double amount;
  final bool isNegative;
  final TextStyle? styleInt;
  final TextStyle? styleDouble;

  const FancyAmountWidget({
    Key? key,
    required this.amount,
    this.isNegative = false,
    this.styleInt,
    this.styleDouble,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final color = isNegative ? recTheme!.red : recTheme!.primaryColor;
    final baseStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w300)
        .merge(styleDouble)
        .copyWith(color: color);

    final locale = AppLocalizations.of(context)?.locale;

    // Get the int segment of the number
    final amountInt = amount.toInt();

    // Get the decimal part of the number
    final decimals = (amount - amountInt);
    final decimalsFormatted = Currency.format(decimals, locale: locale.toString())
        // Replace the first 0, we don't remove ',' or '.',
        // this way we don't need to add it for each locale
        .replaceFirst('0', '');

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: isNegative ? '-' : '+', style: baseStyle),
          TextSpan(text: amountInt.toString(), style: baseStyle.merge(styleInt)),
          TextSpan(text: decimalsFormatted, style: baseStyle),
          TextSpan(text: ' R', style: baseStyle),
        ],
      ),
    );
  }
}
