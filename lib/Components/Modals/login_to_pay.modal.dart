import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/routes.dart';

class LoginToPayModal extends StatelessWidget {
  const LoginToPayModal({Key? key}) : super(key: key);

  static open(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => LoginToPayModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: LocalizedText(
        'LOGIN_TO_PAY',
        uppercase: true,
      ),
      content: LocalizedText(
        'LOGIN_TO_PAY_DESC',
        textAlign: TextAlign.center,
      ),
      icon: Icon(
        Icons.lock,
        size: 32,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
      actions: [
        RecActionButton(
          label: 'REGISTER',
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Routes.register);
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: LocalizedText(
            'LOGIN',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
