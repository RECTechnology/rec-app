import 'package:flutter/material.dart';

class CircleAvatarRec extends StatefulWidget {
  final String imageUrl;

  CircleAvatarRec({
    this.imageUrl,
  });

  @override
  State<StatefulWidget> createState() => _CircleAvatarRecState();
}

class _CircleAvatarRecState extends State<CircleAvatarRec> {
  @override
  Widget build(BuildContext context) {
    var circleAvatarRec = CircleAvatar(
      backgroundImage: NetworkImage("https://picsum.photos/250?image=9"),
    );
    return circleAvatarRec;
  }
}
