import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';

/// Renders a gray box with optional padding
class GrayBox extends StatelessWidget {
  final Widget? child;
  final EdgeInsets padding;
  final double? height;
  final double radius;

  const GrayBox({
    Key? key,
    this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 8.0,
    ),
    this.height = 40,
    this.radius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: recTheme?.defaultAvatarBackground,
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: child,
    );
  }
}
