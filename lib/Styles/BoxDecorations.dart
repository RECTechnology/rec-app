import 'package:flutter/material.dart';
import 'package:rec/Styles/BoxShadows.dart';

class BoxDecorations {
  static BoxDecoration create({
    color = Colors.white,
    BoxShadow shadow,
    double radius = 5,
    double shadowOpacity = 0.2,
    double blurRadius = 0.2,
    Offset offset = const Offset(1, 3),
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        shadow ??
            BoxShadows.createBoxShadow(
              color: Colors.black.withOpacity(shadowOpacity),
              blurRadius: blurRadius,
              offset: offset,
            ),
      ],
    );
  }

  static BoxDecoration infoTooltip({Color color}) {
    return create(
      color: color,
      radius: 50,
      blurRadius: 6,
      offset: Offset(1, 3),
    );
  }

  static BoxDecoration whiteShadowBox() {
    return create(color: Colors.white, blurRadius: 3);
  }
}
