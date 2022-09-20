import 'package:flutter/material.dart';
import 'package:rec/Components/Text/RecAmountText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class OfferDiscount extends StatelessWidget {
  final Offer? offer;

  const OfferDiscount({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final recTheme = RecTheme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (Checks.isNotNull(offer!.initialPrice))
          RecAmountText(
            amount: offer!.initialPrice,
            textStyle: TextStyle(
              color: recTheme!.accentColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        if (Checks.isNotNull(offer!.percentage))
          Text(
            '-${offer!.percentage!.toStringAsFixed(2)}%',
            style: textTheme.headline4!.copyWith(
              color: recTheme!.accentColor,
            ),
          ),
      ],
    );
  }
}
