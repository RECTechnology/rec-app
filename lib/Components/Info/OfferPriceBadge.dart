import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/RecAmountText.dart';
import 'package:rec/helpers/BadgeClipper.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class OfferBadge extends StatelessWidget {
  final Offer? offer;
  final double size;

  const OfferBadge({
    Key? key,
    required this.offer,
    this.size = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (offer!.isPercent && offer!.discountedPrice == null) {
      return SizedBox.shrink();
    }
    if (offer!.initialPrice == null && offer!.discountedPrice == null) {
      return SizedBox.shrink();
    }

    Widget? content;
    var primaryStyle = TextStyle(
      color: Brand.primaryColor,
    );

    if (!offer!.isFree && offer!.initialPrice != null) {
      content = RecAmountText(
        amount: offer!.discountedPrice,
        textStyle: primaryStyle,
      );
    } else if (offer!.isFree) {
      content = LocalizedText(
        'FREE',
        style: primaryStyle.copyWith(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
      );
    }

    return ClipPath(
      clipper: BadgeClipper(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)
            .copyWith(left: 56),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: content,
        ),
      ),
    );
  }
}
