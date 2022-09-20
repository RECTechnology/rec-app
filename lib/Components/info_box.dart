import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';

class InfoBox extends StatelessWidget {
  final List<Widget>? children;
  final Color? backgroundColor;

  const InfoBox({
    Key? key,
    this.children = const [],
    this.backgroundColor,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
   
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? recTheme!.backgroundBanner,
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
