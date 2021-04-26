import 'package:flutter/material.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/ChangePasswordService.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Components/Inputs/PasswordField.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Styles/Paddings.dart';

import 'package:rec/Providers/AppLocalizations.dart';

import '../../../brand.dart';
import '../../../routes.dart';

class SetPasswordPage extends StatefulWidget {
  final String sms;

  SetPasswordPage(this.sms);

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  String newPassword = '+34';
  String confirmNewPassword = '';
  final _formKey = GlobalKey<FormState>();
  final setPassword = ChangePasswordService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Im in iniiiiiiiiit state");
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: Paddings.page,
        child: Column(
          children: [
            topTexts(),
            Form(
              key: _formKey,
              child: Container(
                  child: Column(
                children: [
                  Padding(
                    padding: Paddings.textField,
                    child: PasswordField(
                      validator: Validators.verifyPassword,
                      color: Colors.blueAccent,
                      onChange: setNewPassword,
                    ),
                  ),
                  Padding(
                    padding: Paddings.textField,
                    child: PasswordField(
                      validator: Validators.verifyPassword,
                      color: Colors.blueAccent,
                      onChange: setNewConfirmPassword,
                    ),
                  ),
                ],
              )),
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
                  label: localizations.translate('NEXT'),
                  backgroundColor: Brand.primaryColor,
                  icon: Icons.arrow_forward_ios_sharp,
                  onPressed: changePassword,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget topTexts() {
    var localizations = AppLocalizations.of(context);
    return Column(
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
    var localizations = AppLocalizations.of(context);

    if (_formKey.currentState.validate()) {
      //Hacer llamada a la API para validar sms
      var storage = RecStorage();
      storage.read(key: 'token').then((value) {
        Auth.getAppToken().then((value) {
          setPassword
              .changePassword(
                  code: widget.sms,
                  password: newPassword,
                  repassword: confirmNewPassword,
                  accesToken: value)
              .then((value) {
            RecToast.showInfo(
                context, localizations.translate('PASSWORD_CHANGED_CORRECLY'));
            Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
          }).catchError((error) {
            RecToast.showError(
                context, localizations.translate(error['body']['message']));
          });
        });
      });
    } else {
      RecToast.show(
        context,
        localizations.translate('ERROR_CODE'),
      );
    }
  }
}
