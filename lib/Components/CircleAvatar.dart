import 'package:flutter/material.dart';

class CircleAvatarRec extends StatefulWidget {
  final String imageUrl;
  final double size;

  CircleAvatarRec({
    this.imageUrl,
    this.size = 45.0,
  });

  @override
  State<StatefulWidget> createState() => _CircleAvatarRecState();
}

class _CircleAvatarRecState extends State<CircleAvatarRec> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: CircleAvatar(
        backgroundImage: widget.imageUrl != null && widget.imageUrl.isNotEmpty
            ? NetworkImage(widget.imageUrl)
            : AssetImage('assets/logo.png'),
      ),
    );
  }
}
