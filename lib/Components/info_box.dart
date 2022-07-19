import 'package:flutter/material.dart';
import 'package:rec/config/brand.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({
    Key? key,
    this.children = const [],
    this.backgroundColor = Brand.backgroundBanner,
  }) : super(key: key);

  final List<Widget>? children;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children ?? [],
      ),
    );
  }
}
