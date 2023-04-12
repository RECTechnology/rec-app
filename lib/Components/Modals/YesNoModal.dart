import 'package:flutter/material.dart';
import 'package:rec/Components/Modals/GenericModal.dart';
import 'package:rec/Components/Text/LocalizedText.dart';

class YesNoModal extends GenericModal {
  final Widget? title;
  final Widget? content;
  final BuildContext context;
  final Color? yesTextColor;

  YesNoModal({
    required this.context,
    this.title,
    this.content,
    this.yesTextColor,
    String? yesText,
    String? noText,
  }) : super(
          content: content,
          title: title,
          widget: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => GenericModal.closeDialog(context, false),
                child: LocalizedText(
                  noText ?? 'CANCEL',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => GenericModal.closeDialog(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: yesTextColor,
                  foregroundColor: Colors.white,
                ),
                child: LocalizedText(
                  yesText ?? 'DELETE',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.white),
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
