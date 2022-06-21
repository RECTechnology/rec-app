import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetSVGIcon extends StatelessWidget {
  final String iconAssetName;
  final Color? color;
  final double size;

  const AssetSVGIcon({
    required this.iconAssetName,
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

class NetworkSVGIcon extends StatelessWidget {
  final String url;
  final Color? color;
  final double size;

  const NetworkSVGIcon({
    required this.url,
    Key? key,
    this.color,
    this.size = 24,
  })  : assert(url != ''),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SvgPicture.network(
        url,
        color: color,
        width: size,
        height: size,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
