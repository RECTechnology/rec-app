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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(radius),
      ),
      child: Material(
        color: recTheme?.defaultAvatarBackground,
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
