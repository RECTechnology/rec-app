import 'dart:ui';

import 'package:flutter/material.dart';

class Blurred extends StatelessWidget {
  const Blurred({
    Key? key,
    this.child,
    this.sigmaX = 10,
    this.sigmaY = 2,
    this.blur = true,
  }) : super(key: key);

  const Blurred.conditional({
    this.child,
    this.sigmaX = 10,
    this.sigmaY = 2,
    required this.blur,
  });

  final double sigmaX;
  final double sigmaY;
  final Widget? child;
  final bool blur;

  @override
  Widget build(BuildContext context) {
    if (!blur) return child!;

    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
      child: child,
    );
  }
}
