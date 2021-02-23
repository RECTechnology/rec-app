import 'package:flutter/material.dart';
import 'package:rec/Components/ButtonRec.dart';

class IconButtonRec extends StatefulWidget {
  final Icon icon;
  final ButtonRec button;

  IconButtonRec({
    this.icon,
    this.button,
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
      onPressed: widget.button.onPressed,
    );
  }
}