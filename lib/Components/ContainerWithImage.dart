import 'package:flutter/material.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ContainerWithImage extends StatelessWidget {
  final double? height;
  final String? image;
  final BorderRadius borderRadius;
  final Color color;

  const ContainerWithImage({
    Key? key,
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
                image: NetworkImage(image!),
              )
            : null,
      ),
    );
  }
}
