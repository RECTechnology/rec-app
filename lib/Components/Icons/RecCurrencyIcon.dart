import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecCurrencyIcon extends StatelessWidget {
  final String iconAssetName = 'assets/custom-icons/rec-currency-symbol.svg';
  final Color color;

  const RecCurrencyIcon({
    Key key,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SvgPicture.asset(
        iconAssetName,
        color: color,
      ),
    );
  }
}
