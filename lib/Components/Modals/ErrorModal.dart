import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Modals/GenericModal.dart';

class ErrorModal extends GenericModal {
  @override
  final Text title;
  @override
  final Text content;
  final BuildContext context;

  ErrorModal({this.title, this.context, this.content})
      : super(
          content: content,
          title: title,
          widget: Container(
            width: 150,
            height: 150,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close me!'),
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
