import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Helpers/Validators.dart';

class SetPasswordPage extends StatefulWidget {
  SetPasswordPage();

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  String newPassword = '+34';
  String confirmNewPassword = '';

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: EmptyAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(32, 20, 32, 20),
              child: Text(
                localizations.translate('FORGOT_PASSWORD'),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(32, 0, 50, 39),
              child: Text(
                localizations.translate('INTRODUCE_NEW_PASSWORD'),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: RecTextField(
                placeholder: localizations.translate('NEW_PASSWORD'),
                needObscureText: true,
                keyboardType: TextInputType.text,
                isPassword: false,
                isNumeric: false,
                icon: Icon(Icons.lock),
                colorLine: Colors.blueAccent,
                onChange: setNewPassword,
                isPhone: false,
                validator: Validators.verifyPassword,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: RecTextField(
                placeholder: localizations.translate('REPEAT_PASSWORD'),
                needObscureText: true,
                keyboardType: TextInputType.text,
                isPassword: false,
                isNumeric: false,
                icon: Icon(Icons.lock),
                colorLine: Colors.blueAccent,
                onChange: setNewPassword,
                isPhone: false,
                validator: Validators.verifyPassword,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 203, 0, 0),
              width: 296,
              height: 48,
              child: RecActionButton(
                onPressed: changePassword,
                label: localizations.translate('NEXT'),
                icon: Icons.arrow_forward_ios_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setNewPassword(String newPassword) {
    this.newPassword = newPassword;
  }

  void setNewConfirmPassword(String confirmPassword) {
    confirmNewPassword = confirmPassword;
  }

  void changePassword() {}
}
