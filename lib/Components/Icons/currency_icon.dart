import 'package:flutter/material.dart';
import 'package:rec/Components/Icons/svg_icon.dart';
import 'package:rec/config/theme.dart';

class CurrencyIcon extends StatelessWidget {
  final Color? color;
  final double size;

  const CurrencyIcon({
    Key? key,
    this.color = Colors.white,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assets = RecTheme.of(context)!.assets;

    return AssetSVGIcon(
      iconAssetName: assets.currency,
      color: color,
      size: size,
    );
  }
}
