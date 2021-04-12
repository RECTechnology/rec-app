import 'package:flutter/material.dart';
import 'package:rec/Helpers/ColorHelper.dart';

class CircleAvatarRec extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String seed;
  final double size;

  CircleAvatarRec({
    String imageUrl,
    String name,
    String seed,
    double size = 45.0,
  })  : imageUrl = imageUrl,
        name = name,
        size = size,
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
    if (widget.imageUrl != null && widget.imageUrl.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(widget.imageUrl),
      );
    }

    var randomColor = ColorHelper.getRandomColorForSeed(getSeed());
    if (widget.name != null) {
      return CircleAvatar(
        backgroundColor: randomColor,
        child: Text(
          widget.name[0].toUpperCase(),
          style: TextStyle(color: ColorHelper.getContrastColor(randomColor)),
        ),
      );
    }

    return CircleAvatar(
      backgroundColor: randomColor,
      child: Text(
        'P',
        style: TextStyle(color: ColorHelper.getContrastColor(randomColor)),
      ),
    );
  }
}
