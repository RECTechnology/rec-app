import 'package:flutter/material.dart';
import 'package:rec/styles/box_shadows.dart';

class BoxDecorations {
  static BoxDecoration create({
    color = Colors.white,
    BoxShadow? shadow,
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

  static BoxDecoration radius({
    color = Colors.white,
    double radius = 5,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static BoxDecoration infoTooltip({Color? color}) {
    return create(
      color: color,
      radius: 50,
      blurRadius: 6,
      offset: Offset(1, 3),
    );
  }

  static BoxDecoration outline({
    required Color color,
    double width = 1,
    double radius = 6,
  }) {
    return BoxDecoration(
      border: Border.all(color: color, width: width),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static BoxDecoration transparentBorder({double radius = 6}) {
    return BoxDecoration(
      border: Border.all(
        color: Colors.transparent,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(radius),
      ),
    );
  }

  static BoxDecoration solid(Color color) {
    return BoxDecoration(color: color);
  }

  static BoxDecoration gradient(Gradient gradient) {
    return BoxDecoration(gradient: gradient);
  }

  static BoxDecoration whiteShadowBox() {
    return create(color: Colors.white, blurRadius: 3);
  }
}
