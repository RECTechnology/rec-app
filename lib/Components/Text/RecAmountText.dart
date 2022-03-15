import 'package:flutter/material.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RecAmountText extends StatelessWidget {
  final TextStyle textStyle;
  final num? amount;
  final String symbol;

  const RecAmountText({
    Key? key,
    this.amount = 0,
    this.textStyle = const TextStyle(),
    this.symbol = 'R',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return RichText(
      text: TextSpan(
        style: TextStyle(letterSpacing: 0),
        children: [
          TextSpan(
            text: Currency.format(amount),
            style: textTheme.headline3!
                .copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                )
                .merge(textStyle),
          ),
          TextSpan(
            text: symbol,
            style: textTheme.headline4!
                .copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                )
                .merge(textStyle),
          ),
        ],
      ),
    );
  }
}
