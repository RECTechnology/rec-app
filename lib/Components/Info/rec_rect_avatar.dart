import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rec/Components/Info/initial_text_widget.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RectAvatarRec extends StatefulWidget {
  final String? imageUrl;
  final Uint8List? imageBytes;
  final String? name;
  final String? seed;
  final Icon? icon;
  final Color? color;
  final double? radius;
  final ImageProvider? image;

  final double width;
  final double height;

  RectAvatarRec({
    this.imageUrl,
    this.name,
    this.image,
    this.icon,
    this.color,
    this.imageBytes,
    this.radius,
    String? seed,
    this.width = 64,
    this.height = 64,
  }) : seed = seed ?? name;

  /// Returns a CircleAvatar from an account
  RectAvatarRec.fromAccount(
    Account account, {
    String? seed,
    this.color,
    this.radius,
    this.image,
    this.width = 64,
    this.height = 64,
  })  : imageUrl = account.companyImage,
        name = account.name,
        icon = null,
        imageBytes = null,
        seed = seed ?? account.name;

  /// Returns a CircleAvatar with an Icon as the child
  RectAvatarRec.withIcon(
    this.icon, {
    this.color,
    String? seed,
    this.radius,
    this.image,
    this.width = 64,
    this.height = 64,
  })  : imageUrl = null,
        imageBytes = null,
        name = null,
        seed = seed ?? icon!.semanticLabel;

  RectAvatarRec.withImageUrl(
    this.imageUrl, {
    this.color,
    String? seed,
    this.radius,
    this.image,
    this.name,
    this.width = 64,
    this.height = 64,
  })  : icon = null,
        imageBytes = null,
        seed = seed ?? name;

  @override
  State<StatefulWidget> createState() => _RectAvatarRecState();
}

class _RectAvatarRecState extends State<RectAvatarRec> {
  int getSeed() {
    return (widget.seed ?? widget.name).hashCode;
  }

  Widget buildRectAvatar({
    DecorationImage? image,
    Widget? child,
  }) {
    assert(image != null || child != null, "Either the image or child must be supplied");

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Brand.primaryColor,
        image: image,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Checks.isNotEmpty(widget.imageUrl)) {
      return buildRectAvatar(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            widget.imageUrl!,
          ),
        ),
      );
    }

    if (Checks.isNotNull(widget.image)) {
      return buildRectAvatar(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: widget.image!,
        ),
      );
    }

    if (Checks.isNotEmpty(widget.imageBytes)) {
      return buildRectAvatar(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(widget.imageBytes!),
        ),
      );
    }

    return buildRandom();
  }

  Widget buildRandom() {
    return Container(
      height: 64,
      width: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Brand.primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FittedBox(
          child: Center(
            child: InitialTextWidget(
              defaultName: 'Particular',
              seed: getSeed(),
              icon: widget.icon,
              name: widget.name,
            ),
          ),
        ),
      ),
    );
  }
}
