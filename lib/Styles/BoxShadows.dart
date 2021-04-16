import 'package:flutter/material.dart';

class BoxShadows {
  static BoxShadow createBoxShadow({
    @required Color color,
    double blurRadius = 3,
    Offset offset = const Offset(1, 3),
  }) {
    return BoxShadow(
      color: color,
      blurRadius: blurRadius,
      offset: offset,
    );
  }

  static BoxShadow elevation1() {
    return createBoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 3,
      offset: Offset(1, 3),
    );
  }

  static BoxShadow elevation2() {
    return createBoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 6,
      offset: Offset(1, 3),
    );
  }

  static BoxShadow elevation3() {
    return createBoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 8,
      offset: Offset(1, 3),
    );
  }
}
