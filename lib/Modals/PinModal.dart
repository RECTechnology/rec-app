import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Modals/GenericModal.dart';

class PinModal extends GenericModal {
  final Text title;
  final Text content;
  final BuildContext context;

  PinModal({this.title, this.context, this.content})
      : super(
          content: content,
          title: title,
          widget: Container(
            width: 400,
            height: 150,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Introduzca su Pin',
              ),
            ),
          ),
        );

  void showDialog() {
    super.showAlertDialog(context);
  }

  void closeModal() {
    super.closeDialog(context);
  }
}