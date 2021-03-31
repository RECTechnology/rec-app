import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Modals/GenericModal.dart';

class YesNoModal extends GenericModal {
  @override
  final Text title;
  @override
  final Text content;
  final BuildContext context;

  YesNoModal({this.title, this.context, this.content})
      : super(
          content: content,
          title: title,
          widget: Row(
            children: [
              Container(
                width: 150,
                height: 150,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Yes'),
                ),
              ),
              Container(
                width: 150,
                height: 150,
                child: TextButton(
                  onPressed: () {},
                  child: Text('No'),
                ),
              )
            ],
          ),
        );

  void showDialog() {
    super.showAlertDialog(context);
  }

  void closeModal() {
    super.closeDialog(context);
  }
}