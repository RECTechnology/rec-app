import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';

/// Renders a gray box with optional padding
class GrayBox extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final double radius;
  final VoidCallback? onTap;
  final Color? background;

  const GrayBox({
    Key? key,
    this.child,
    this.width,
    this.height = 40,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 8.0,
    ),
    this.radius = 8,
    this.onTap,
    this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(radius),
      ),
      child: Material(
        color: background ?? recTheme?.defaultAvatarBackground,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            padding: padding,
            width: width,
            child: child,
          ),
        ),
      ),
    );
  }
}

class GradientBox extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GradientBox({
    Key? key,
    required this.child,
    this.gradient,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: gradient ?? recTheme?.gradientPrimary,
          ),
          child: child,
        ),
      ),
    );
  }
}
