import 'package:flutter/material.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/public/RecoverPasswordService.dart';
import 'package:rec/Components/Inputs/PasswordField.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Layout/FormPageLayout.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/Entities/Forms/DniPhoneData.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Styles/Paddings.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class SetPasswordPage extends StatefulWidget {
  final DniPhoneData data;
  final String sms;

  SetPasswordPage(this.data, this.sms);

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  String newPassword = '';
  String confirmNewPassword = '';

  final _formKey = GlobalKey<FormState>();
  final _recoverPasswordService = RecoverPasswordService();

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
        onPressed: () => _next(),
      ),
    );
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

  void setNewPassword(String newPassword) {
    this.newPassword = newPassword;
  }

  void setNewConfirmPassword(String confirmPassword) {
    confirmNewPassword = confirmPassword;
  }

  void _next() {
    if (!_formKey.currentState.validate()) return;

    Loading.show();
    FocusScope.of(context).requestFocus(FocusNode());
    Auth.getAppToken().then((appToken) {
      _recoverPasswordService
          .recoverPassword(
            code: widget.sms,
            password: newPassword,
            repassword: confirmNewPassword,
            phone: widget.data.phone,
            prefix: widget.data.prefix,
            dni: widget.data.dni,
          )
          .then(_changePasswordOK)
          .catchError(_changePasswordKO);
    });
  }

  void _changePasswordOK(value) {
    var localizations = AppLocalizations.of(context);

    Loading.dismiss();
    RecToast.showInfo(
      context,
      localizations.translate('PASSWORD_CHANGED_CORRECLY'),
    );
    Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
  }

  void _changePasswordKO(error) {
    var localizations = AppLocalizations.of(context);

    Loading.dismiss();
    RecToast.showError(
      context,
      localizations.translate(error.message),
    );
  }
}
