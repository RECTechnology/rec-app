import 'package:flutter/material.dart';
import 'package:rec/Api/HandledErrors.dart';
import 'package:rec/Api/Services/public/LoginService.dart';
import 'package:rec/Components/Forms/Login.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/RecHeader.dart';

import 'package:rec/Entities/Forms/LoginData.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Public/ForgotPassword/ForgotPassword.dart';
import 'package:rec/Pages/Public/MustUpdate.dart';
import 'package:rec/Pages/Public/ValidatePhone.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/routes.dart';

class LoginPage extends StatefulWidget {
  final Function onLogin;
  final String dni;

  const LoginPage({
    Key key,
    this.onLogin,
    this.dni,
  }) : super(key: key);

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
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RecHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: Paddings.page,
                child: Column(
                  children: [
                    LoginForm(
                      formKey: _formKey,
                      onChange: (data) {
                        setState(() => loginData = data);
                      },
                      onSubmitted: (data) {
                        setState(() => loginData = data);
                        _loginButtonPressed();
                      },
                    ),
                    _forgotPassLink(),
                    RecActionButton(
                      label: 'LOGIN',
                      onPressed: _loginButtonPressed,
                      icon: Icons.arrow_forward_ios,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        (!hasSavedUser)
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(0, 60, 0, 16),
                                child: Text(
                                  localizations.translate('NOT_REGISTRED'),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              )
                            : SizedBox(),
                        (!hasSavedUser) ? _registerButton() : SizedBox(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
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

    var appState = AppState.of(context, listen: false);
    loginData.version = appState.versionInt;

    await Loading.show();
    await loginService
        .login(loginData)
        .then(_onLoginSuccess)
        .catchError(_onLoginError);
  }

  dynamic _onLoginSuccess(response) {
    Loading.dismiss();

    if (widget.onLogin != null) return widget.onLogin();

    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  dynamic _onLoginError(error) {
    Loading.dismiss();
    RecToast.showError(context, error.message);

    if (error.message == HandledErrors.userPhoneNotValidated) {
      return Navigator.of(context).push(
        MaterialPageRoute(
          builder: (c) => ValidatePhone(dni: loginData.username),
        ),
      );
    }

    if (error.message == HandledErrors.mustUpdate) {
      return Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (c) => MustUpdate(),
        ),
      );
    }
  }
}
