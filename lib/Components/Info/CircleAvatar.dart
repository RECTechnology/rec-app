import 'package:flutter/material.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Helpers/ColorHelper.dart';

class CircleAvatarRec extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String seed;
  final Icon icon;
  final Color color;

  CircleAvatarRec({
    String imageUrl,
    String name,
    String seed,
    Icon icon,
    Color color,
  })  : imageUrl = imageUrl,
        name = name,
        icon = icon,
        color = color,
        seed = seed ?? name;

  /// Returns a CircleAvatar from an account
  CircleAvatarRec.fromAccount(
    Account account, {
    String seed,
    Color color,
  })  : imageUrl = account.publicImage,
        name = account.name,
        icon = null,
        color = color,
        seed = seed ?? account.name;

  /// Returns a CircleAvatar with an Icon as the child
  CircleAvatarRec.withIcon(
    Icon icon, {
    String seed,
    Color color,
  })  : icon = icon,
        imageUrl = null,
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
    if (widget.imageUrl != null && widget.imageUrl.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(widget.imageUrl),
      );
    }

    var randomColor = ColorHelper.getRandomColorForSeed(getSeed());

    Widget child = Text(
      'P',
      style: TextStyle(color: ColorHelper.getContrastColor(randomColor)),
    );

    if (widget.icon != null) {
      child = widget.icon;
    }

    if (widget.name != null) {
      child = Text(
        widget.name[0].toUpperCase(),
        style: TextStyle(color: ColorHelper.getContrastColor(randomColor)),
      );
    }

    return CircleAvatar(
      backgroundColor: widget.color ?? randomColor,
      child: child,
    );
  }
}