import 'package:flutter/material.dart';
import 'package:rec/Api/Services/LoginService.dart';
import 'package:rec/Components/Forms/Login.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/RecHeader.dart';

import 'package:rec/Entities/Forms/LoginData.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Public/ForgotPassword/ForgotPassword.dart';
import 'package:rec/Pages/Public/ValidatePhone.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginData loginData = LoginData();
  LoginService loginService = LoginService();

  final _formKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<LoginFormState>();

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
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                RecHeader(),
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
                        onPressed: _loginButtonPressed,
                        icon: Icons.arrow_forward_ios,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: Paddings.page,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    (!hasSavedUser)
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(0, 70, 0, 16),
                            child: Text(
                              localizations.translate('NOT_REGISTRED'),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        : SizedBox(),
                    (!hasSavedUser) ? _registerButton() : SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forgotPassLink() {
    var localizations = AppLocalizations.of(context);
    return InkWell(
      onTap: _goToForgotPassword,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          alignment: Alignment.topRight,
          child: Text(
            localizations.translate('FORGOT_PASSWORD'),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: RecActionButton(
        label: 'REGISTER',
        onPressed: _registerButtonPressed,
        padding: EdgeInsets.all(0),
      ),
    );
  }

  Future _goToForgotPassword() {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (c) => ForgotPassword()),
    );
  }

  void _registerButtonPressed() {
    Navigator.of(context).pushNamed(Routes.register);
  }

  void _loginButtonPressed() async {
    if (!_formKey.currentState.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());
    await Loading.show();

    await loginService
        .login(loginData)
        .then(_onLoginSuccess)
        .catchError(_onLoginError);

    await Loading.dismiss();
  }

  void _onLoginSuccess(response) {
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  void _onLoginError(error) {
    RecToast.showError(context, error['body']['error_description']);
    if (error['body']['error_description'] == 'User without phone validated') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (c) => ValidatePhone(dni: loginData.username),
        ),
      );
    }
  }
}
