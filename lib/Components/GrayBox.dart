import 'package:flutter/material.dart';
import 'package:rec/brand.dart';

/// Renders a gray box with optional padding
class GrayBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double height;

  const GrayBox({
    Key key,
    this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 8.0,
    ),
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Brand.defaultAvatarBackground,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: child,
    );
  }
}