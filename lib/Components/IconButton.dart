import 'package:flutter/material.dart';

class IconButtonRec extends StatefulWidget {
  final Icon icon;
  final Function() onPressed;

  IconButtonRec({
    this.icon,
    this.onPressed,
  });

  @override
  State<StatefulWidget> createState() {
    return IconButtonRecState();
  }
}

class IconButtonRecState extends State<IconButtonRec> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.icon,
      onPressed: widget.onPressed,
    );
  }
}
