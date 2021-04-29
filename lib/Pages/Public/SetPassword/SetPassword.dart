import 'package:flutter/material.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/ChangePasswordService.dart';
import 'package:rec/Components/Inputs/PasswordField.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Styles/Paddings.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class SetPasswordPage extends StatefulWidget {
  final String sms;

  SetPasswordPage(this.sms);

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  String newPassword = '';
  String confirmNewPassword = '';

  final _formKey = GlobalKey<FormState>();
  final setPassword = ChangePasswordService();

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: EmptyAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: Paddings.pageNoTop,
            child: Column(
              children: [
                topTexts(),
                SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: Paddings.textField,
                          child: PasswordField(
                            autofocus: true,
                            validator: Validators.verifyPassword,
                            color: Colors.blueAccent,
                            onChange: setNewPassword,
                          ),
                        ),
                        Padding(
                          padding: Paddings.textField,
                          child: PasswordField(
                            title: 'REPASSWORD',
                            validator: Validators.verifyPassword,
                            color: Colors.blueAccent,
                            onChange: setNewConfirmPassword,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 24,
              left: 32,
              right: 32,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RecActionButton(
                label: localizations.translate('CHANGE'),
                backgroundColor: Brand.primaryColor,
                icon: Icons.arrow_forward_ios_sharp,
                onPressed: changePassword,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget topTexts() {
    return Column(
      children: [
        TitleText('FORGOT_PASSWORD'),
        SizedBox(height: 16),
        CaptionText('INTRODUCE_NEW_PASSWORD'),
      ],
    );
  }

  void setNewPassword(String newPassword) {
    this.newPassword = newPassword;
  }

  void setNewConfirmPassword(String confirmPassword) {
    confirmNewPassword = confirmPassword;
  }

  void changePassword() {
    if (!_formKey.currentState.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());
    Auth.getAppToken().then((appToken) {
      setPassword
          .changePassword(
            code: widget.sms,
            password: newPassword,
            repassword: confirmNewPassword,
            accesToken: appToken,
          )
          .then(_changePasswordOK)
          .catchError(_changePasswordKO);
    });
  }

  void _changePasswordOK(value) {
    var localizations = AppLocalizations.of(context);
    RecToast.showInfo(
      context,
      localizations.translate('PASSWORD_CHANGED_CORRECLY'),
    );
    Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
  }

  void _changePasswordKO(error) {
    var localizations = AppLocalizations.of(context);
    RecToast.showError(
      context,
      localizations.translate(error.message),
    );
  }
}
