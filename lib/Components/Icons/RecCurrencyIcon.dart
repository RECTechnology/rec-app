import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rec/config/assets.dart';

class RecCurrencyIcon extends StatelessWidget {
  final String iconAssetName = Assets.recCurrency;
  final Color? color;
  final double size;

  const RecCurrencyIcon({
    Key? key,
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
