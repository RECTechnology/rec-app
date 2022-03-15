import 'dart:ui';

import 'package:flutter/material.dart';

class BluredImageContainer extends StatelessWidget {
  const BluredImageContainer({
    Key? key,
    this.child,
    this.image,
    this.sigmaX = 6,
    this.sigmaY = 6,
  }) : super(key: key);

  final double sigmaX;
  final double sigmaY;
  final Widget? child;
  final ImageProvider<Object>? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image!,
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        blendMode: BlendMode.src,
        child: Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 100,
            bottom: 32,
          ),
          color: Colors.white.withAlpha(100),
          child: child,
        ),
      ),
    );
  }
}
