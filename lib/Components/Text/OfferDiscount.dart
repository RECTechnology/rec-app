import 'package:flutter/material.dart';
import 'package:rec/Components/Text/RecAmountText.dart';
import 'package:rec/Entities/Offer.ent.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/brand.dart';

class OfferDiscount extends StatelessWidget {
  final Offer offer;

  const OfferDiscount({Key key, @required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (Checks.isNotNull(offer.initialPrice))
          RecAmountText(
            amount: offer.initialPrice,
            textStyle: TextStyle(
              color: Brand.accentColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        if (Checks.isNotNull(offer.percentage))
          Text(
            '-${offer.percentage.toStringAsFixed(2)}%',
            style: textTheme.headline4.copyWith(
              color: Brand.accentColor,
            ),
          ),
      ],
    );
  }
}
