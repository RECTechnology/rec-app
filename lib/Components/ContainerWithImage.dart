import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ContainerWithImage extends StatelessWidget {
  final double? height;
  final String? image;
  final Color? color;
  final BorderRadius borderRadius;

  const ContainerWithImage({
    Key? key,
    this.height,
    this.image,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color ?? recTheme!.defaultAvatarBackground,
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
