import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rec/Api/Services/LoginService.dart';
import 'package:rec/Components/Forms/Login.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';

import 'package:rec/Entities/Forms/LoginData.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Public/ForgotPassword/ForgotPassword.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginData loginData = LoginData();

  final _formKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<LoginFormState>();

  LoginService loginService = LoginService();

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var localizations = AppLocalizations.of(context);
    var savedUser = userState.savedUser;
    var hasSavedUser = userState.hasSavedUser();

    if (hasSavedUser) {
      _loginFormKey.currentState?.setUsername(savedUser.username);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _header(),
            Padding(
              padding: Paddings.page,
              child: Column(
                children: [
                  LoginForm(
                    formKey: _formKey,
                    onChange: (data) {
                      setState(() => loginData = data);
                    },
                  ),
                  _forgotPassLink(),
                  RecActionButton(
                    label: 'LOGIN',
                    onPressed: loginButtonPressed,
                    icon: Icons.arrow_forward_ios,
                  ),
                  (!hasSavedUser)
                      ? Container(
                          alignment: Alignment.center,
                          width: 300,
                          margin: EdgeInsets.fromLTRB(0, 70, 0, 16),
                          child: Text(
                            localizations.translate('NOT_REGISTRED'),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        )
                      : SizedBox(),
                  (!hasSavedUser) ? _registerButton() : SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _forgotPassLink() {
    var localizations = AppLocalizations.of(context);
    return Container(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          style: TextStyles.link,
          text: localizations.translate('FORGOT_PASSWORD'),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => ForgotPassword(
                    isChangePassword: true,
                  ),
                ),
              );
            },
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: RecActionButton(
        label: 'REGISTER',
        onPressed: registerButtonPressed,
        padding: EdgeInsets.all(0),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Image(
        image: AssetImage('assets/login-header.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }

  void registerButtonPressed() {
    Navigator.of(context).pushNamed(Routes.register);
  }

  void loginButtonPressed() async {
    if (!_formKey.currentState.validate()) return;

    await EasyLoading.show();

    await loginService
        .login(loginData)
        .then(onLoginSuccess)
        .catchError(onLoginError);

    await EasyLoading.dismiss();
  }

  void onLoginSuccess(response) {
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  Future<void> onLoginError(error) async {
    RecToast.showError(context, error['body']['error_description']);
    if (error['body']['error_description'] == 'User without phone validated') {
      await EasyLoading.dismiss();

      var validateSMSResult = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (c) => ForgotPassword(
            dni: loginData.username,
            isChangePassword: false,
          ),
        ),
      );

      if (validateSMSResult != null && validateSMSResult['valid']) {
        Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
      }
    }
  }

  void onNotYou(UserState userState) async {
    await userState.unstoreUser();
    _loginFormKey.currentState.setUsername('');
  }
}
