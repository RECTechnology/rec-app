import 'package:flutter/material.dart';
import 'package:rec/config/brand.dart';

class AspectRatioImage extends StatelessWidget {
  final ImageProvider<Object> image;
  final Color fallbackBackgroundColor;
  final double aspectRatio;

  const AspectRatioImage({
    Key? key,
    required this.image,
    required this.aspectRatio,
    this.fallbackBackgroundColor = Brand.defaultAvatarBackground,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: fallbackBackgroundColor,
          borderRadius: BorderRadius.circular(6),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: image,
          ),
        ),
      ),
    );
  }
}
