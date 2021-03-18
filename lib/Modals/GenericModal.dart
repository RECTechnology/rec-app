import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenericModal {
  final Text title;
  final Text content;
  final Widget widget;
  GenericModal({this.title, this.content, this.widget});

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: content,
              content: content,
              actions: <Widget>[widget],
            ));
  }

  void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
