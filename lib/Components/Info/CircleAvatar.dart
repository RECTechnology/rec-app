import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CircleAvatarRec extends StatefulWidget {
  final String? imageUrl;
  final Uint8List? imageBytes;
  final String? name;
  final String? seed;
  final Icon? icon;
  final Color? color;
  final double? radius;
  final AssetImage? image;

  CircleAvatarRec({
    this.imageUrl,
    this.name,
    this.image,
    this.icon,
    this.color,
    this.imageBytes,
    this.radius,
    String? seed,
  }) : seed = seed ?? name;

  /// Returns a CircleAvatar from an account
  CircleAvatarRec.fromAccount(
    Account account, {
    String? seed,
    this.color,
    this.radius,
    this.image,
  })  : imageUrl = account.companyImage,
        name = account.name,
        icon = null,
        imageBytes = null,
        seed = seed ?? account.name;

  /// Returns a CircleAvatar with an Icon as the child
  CircleAvatarRec.withIcon(
    this.icon, {
    this.color,
    String? seed,
    this.radius,
    this.image,
  })  : imageUrl = null,
        imageBytes = null,
        name = null,
        seed = seed ?? icon!.semanticLabel;

  CircleAvatarRec.withImageUrl(
    this.imageUrl, {
    this.color,
    String? seed,
    this.radius,
    this.image,
    this.name,
  })  : icon = null,
        imageBytes = null,
        seed = seed ?? name;

  @override
  State<StatefulWidget> createState() => _CircleAvatarRecState();
}

class _CircleAvatarRecState extends State<CircleAvatarRec> {
  int getSeed() {
    return (widget.seed ?? widget.name).hashCode;
  }

  @override
  Widget build(BuildContext context) {
    if (Checks.isNotEmpty(widget.imageUrl)) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundImage: NetworkImage(
          widget.imageUrl!,
        ),
        onBackgroundImageError: (e, s) {},
      );
    }
    
    if (Checks.isNotNull(widget.image)) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundImage: widget.image,
        onBackgroundImageError: (e, s) {},
      );
    }

    if (Checks.isNotEmpty(widget.imageBytes)) {
      return CircleAvatar(
        backgroundImage: MemoryImage(widget.imageBytes!),
        onBackgroundImageError: (e, s) {},
      );
    }

    return buildRandom();
  }

  CircleAvatar buildRandom() {
    var randomColor = Brand.getRandomColor(getSeed());

    Widget? child = Text(
      'P',
      style: TextStyle(color: Brand.getContrastColor(randomColor)),
    );

    if (widget.icon != null) {
      child = widget.icon;
    }

    if (widget.name != null) {
      var hasName = Checks.isNotEmpty(widget.name);
      var safeName = !hasName ? 'Particular' : widget.name!;

      child = Text(
        safeName[0].toUpperCase(),
        style: TextStyle(color: Brand.getContrastColor(randomColor)),
      );
    }

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: widget.color ?? randomColor,
      child: child,
    );
  }
}
