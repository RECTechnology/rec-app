import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';

class AspectRatioImage extends StatelessWidget {
  final ImageProvider<Object> image;
  final Color? fallbackBackgroundColor;
  final double aspectRatio;

  const AspectRatioImage({
    Key? key,
    required this.image,
    required this.aspectRatio,
    this.fallbackBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: fallbackBackgroundColor ?? recTheme!.defaultAvatarBackground,
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
