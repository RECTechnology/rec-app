import 'package:flutter/material.dart';

class BoxDecorations {
  static BoxDecoration create({
    color: Colors.white,
    double radius: 5,
    double boxShadow = 0.2,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(boxShadow),
          blurRadius: 4,
          offset: Offset(1, 4),
        ),
      ],
    );
  }

  static BoxDecoration whiteShadowBox() {
    return create(color: Colors.white);
  }
}
