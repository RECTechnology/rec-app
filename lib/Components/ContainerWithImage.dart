import 'package:flutter/material.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/brand.dart';

class ContainerWithImage extends StatelessWidget {
  final double height;
  final String image;
  final BorderRadius borderRadius;
  final Color color;

  const ContainerWithImage({
    Key key,
    this.height,
    this.image,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.color = Brand.defaultAvatarBackground,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        image: Checks.isNotEmpty(image)
            ? DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(image),
              )
            : null,
      ),
    );
  }
}
