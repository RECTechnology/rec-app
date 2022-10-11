import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/RecAmountText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/BadgeClipper.dart';
import 'package:rec/styles/box_shadows.dart';
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
    if (!offer!.isFree && offer!.isPercent && offer!.discountedPrice == null) {
      return SizedBox.shrink();
    }
    if (!offer!.isFree && offer!.initialPrice == null && offer!.discountedPrice == null) {
      return SizedBox.shrink();
    }

    Widget? content;
    final recTheme = RecTheme.of(context);
    final primaryStyle = TextStyle(
      color: recTheme!.primaryColor,
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

    final clipper = BadgeClipper();

    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: BoxShadows.elevation2(),
      ),
      child: ClipPath(
        clipper: clipper,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16).copyWith(left: 56),
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: content,
          ),
        ),
      ),
    );

    return ClipPath(
      clipper: BadgeClipper(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16).copyWith(left: 56),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadows.elevation2()]),
        child: Center(
          child: content,
        ),
      ),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
