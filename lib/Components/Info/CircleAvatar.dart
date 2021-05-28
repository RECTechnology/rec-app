import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/brand.dart';

class CircleAvatarRec extends StatefulWidget {
  final String imageUrl;
  final Uint8List imageBytes;
  final String name;
  final String seed;
  final Icon icon;
  final Color color;
  final double radius;

  CircleAvatarRec({
    String imageUrl,
    String name,
    String seed,
    Icon icon,
    Color color,
    Uint8List imageBytes,
    this.radius,
  })  : imageUrl = imageUrl,
        name = name,
        icon = icon,
        color = color,
        imageBytes = imageBytes,
        seed = seed ?? name;

  /// Returns a CircleAvatar from an account
  CircleAvatarRec.fromAccount(
    Account account, {
    String seed,
    Color color,
    this.radius,
  })  : imageUrl = account.publicImage,
        name = account.name,
        icon = null,
        imageBytes = null,
        color = color,
        seed = seed ?? account.name;

  /// Returns a CircleAvatar with an Icon as the child
  CircleAvatarRec.withIcon(
    Icon icon, {
    String seed,
    Color color,
    this.radius,
  })  : icon = icon,
        imageUrl = null,
        imageBytes = null,
        name = null,
        color = color,
        seed = seed ?? icon.semanticLabel;

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
        backgroundImage: NetworkImage(widget.imageUrl),
      );
    }

    if (Checks.isNotEmpty(widget.imageBytes)) {
      return CircleAvatar(
        backgroundImage: MemoryImage(widget.imageBytes),
      );
    }

    var randomColor = Brand.getRandomColor(getSeed());

    Widget child = Text(
      'P',
      style: TextStyle(color: Brand.getContrastColor(randomColor)),
    );

    if (widget.icon != null) {
      child = widget.icon;
    }

    if (widget.name != null) {
      var hasName = Checks.isNotEmpty(widget.name);
      var safeName = !hasName ? 'Particular' : widget.name;

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
