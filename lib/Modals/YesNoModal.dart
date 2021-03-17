import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Modals/GenericModal.dart';

class YesNoModal extends GenericModal {
  final Text title;
  final Text content;
  final BuildContext context;

  YesNoModal({this.title, this.context, this.content})
      : super(
      content: content,
      title: title,
      widget: Row(children: [
        Container(
            width: 150,
            height: 150,
            child: FlatButton(
              child: Text('Yes'),
            ),
        ),
        Container(
            width: 150,
            height: 150,
            child: FlatButton(
              child: Text('No'),
            ),)
      ],),);

  void showDialog() {
    super.showAlertDialog(context);
  }

  void closeModal() {
    super.closeDialog(context);
  }
}
