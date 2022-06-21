import 'package:flutter/material.dart';
import 'package:rec/Components/Icons/svg_icon.dart';
import 'package:rec/config/assets.dart';

class PercentageIcon extends StatelessWidget {
  final String iconAssetName = Assets.percentDiscount;
  final Color color;
  final double size;

  PercentageIcon({
    Key? key,
    this.color = Colors.white,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AssetSVGIcon(
      iconAssetName: iconAssetName,
      color: color,
      size: size,
    );
  }
}
