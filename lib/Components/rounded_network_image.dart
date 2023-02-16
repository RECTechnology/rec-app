import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/boxes.dart';
import 'package:rec/Components/Text/LocalizedText.dart';

class RoundedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const RoundedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width = 72,
    this.height = 72,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      child: CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (c, e, s) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        errorWidget: (c, e, s) {
          return GrayBox(
            child: Center(
              child: LocalizedText('ERROR'),
            ),
          );
        },
      ),
    );
  }
}
