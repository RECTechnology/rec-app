import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PercentageIcon extends StatelessWidget {
  final String iconAssetName = 'assets/custom-icons/percentage-discount.svg';
  final Color color;
  final double size;

  const PercentageIcon({
    Key key,
    this.color = Colors.white,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SvgPicture.asset(
        iconAssetName,
        color: color,
        width: size,
        height: size,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}