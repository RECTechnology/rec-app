import 'package:flutter/material.dart';
import 'package:rec/Components/Modals/GenericModal.dart';
import 'package:rec/Components/Text/LocalizedText.dart';

class YesNoModal extends GenericModal {
  final Widget? title;
  final Widget? content;
  final BuildContext context;

  YesNoModal({
    this.title,
    required this.context,
    this.content,
  }) : super(
          content: content,
          title: title,
          widget: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => GenericModal.closeDialog(context, true),
                child: LocalizedText(
                  'DELETE',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              TextButton(
                onPressed: () => GenericModal.closeDialog(context, false),
                child: LocalizedText(
                  'CANCEL',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        );

  Future showDialog(context) {
    return super.showAlertDialog(context);
  }

  void closeModal(dynamic result) {
    GenericModal.closeDialog(context, result);
  }
}
