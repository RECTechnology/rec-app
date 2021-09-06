import 'package:flutter/material.dart';

/// Clips a triangle from the left of the rectangle
class BadgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Inset arrow
    path.lineTo(0, 0);
    path.lineTo(30, size.height * 0.5);
    path.lineTo(0, size.height);

    // Rest of rect
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
