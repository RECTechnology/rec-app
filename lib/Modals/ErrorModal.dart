import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Modals/GenericModal.dart';

class ErrorModal extends GenericModal {
  final Text title;
  final Text content;
  final BuildContext context;

  ErrorModal({this.title, this.context, this.content})
      : super(
            content: content,
            title: title,
            widget: Container(
                width: 150,
                height: 150,
                child: FlatButton(
                  child: Text('Close me!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )));

  void showDialog() {
    super.showAlertDialog(context);
  }

  void closeModal() {
    super.closeDialog(context);
  }
}
