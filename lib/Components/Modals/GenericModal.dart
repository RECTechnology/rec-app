import 'package:flutter/material.dart';

class GenericModal {
  final Widget title;
  final Widget content;
  final Widget widget;
  GenericModal({
    this.title,
    this.content,
    this.widget,
  });

  Future showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[widget],
      ),
    );
  }

  Future showSimpleDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        child: widget,
      ),
    );
  }

  static void closeDialog(BuildContext context, dynamic result) {
    Navigator.of(context).pop(result);
  }
}
