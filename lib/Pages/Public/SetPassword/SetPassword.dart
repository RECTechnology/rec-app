import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/text_fields/PasswordField.dart';
import 'package:rec/Components/Layout/FormPageLayout.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class SetPasswordPage extends StatefulWidget {
  final DniPhoneData? data;
  final String sms;
  final RecoverPasswordService service;

  SetPasswordPage(
    this.data,
    this.sms, {
    RecoverPasswordService? service,
  }) : service = service ?? RecoverPasswordService(env: env);

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String newPassword = '';
  String confirmNewPassword = '';

  @override
  Widget build(BuildContext context) {
    return FormPageLayout(
      appBar: EmptyAppBar(context),
      header: _topTexts(),
      form: _changePassForm(),
      submitButton: RecActionButton(
        label: 'CHANGE',
        backgroundColor: Brand.primaryColor,
        icon: Icons.arrow_forward_ios_sharp,
        // TODO: only allow to click next if form is valid, otherwise disable
        // something like: `onPressed: isValid ? _onPressed: null,`
        onPressed: () => _next(),
      ),
    );
  }

  void setNewConfirmPassword(String confirmPassword) {
    confirmNewPassword = confirmPassword;
  }

  void setNewPassword(String newPassword) {
    this.newPassword = newPassword;
  }

  Widget _changePassForm() {
    return Form(
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
    );
  }

  void _changePasswordKO(error) {
    Loading.dismiss();
    RecToast.showError(context, error.message);
  }

  void _changePasswordOK(value) {
    Loading.dismiss();
    RecToast.showInfo(context, 'PASSWORD_CHANGED_CORRECLY');
    Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;

    Loading.show();
    FocusScope.of(context).requestFocus(FocusNode());
    Auth.getAppToken().then((appToken) {
      widget.service
          .recoverPassword(
            RecoverPasswordData(
              code: widget.sms,
              password: newPassword,
              repassword: confirmNewPassword,
              phone: widget.data!.phone,
              prefix: widget.data!.prefix,
              dni: widget.data!.dni,
            ),
          )
          .then(_changePasswordOK)
          .catchError(_changePasswordKO);
    });
  }

  Widget _topTexts() {
    return Column(
      children: [
        TitleText('CHANGE_PASSWORD'),
        SizedBox(height: 16),
        CaptionText('INTRODUCE_NEW_PASSWORD'),
        SizedBox(height: 24),
      ],
    );
  }
}
