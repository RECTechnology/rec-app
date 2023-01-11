import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/Login.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/RecHeader.dart';
import 'package:rec/Components/Text/LinkText.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/Pages/Public/forgot_password.dart';
import 'package:rec/Pages/Public/MustUpdate.dart';
import 'package:rec/Pages/Public/validate_phone.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/providers/app_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class LoginPage extends StatefulWidget {
  final Function? onLogin;
  final String? dni;

  const LoginPage({
    Key? key,
    this.onLogin,
    this.dni,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginData loginData = LoginData();
  LoginService loginService = LoginService(env: env);

  final _formKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<LoginFormState>();

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var savedUser = userState.savedUser;
    var hasSavedUser = userState.hasSavedUser();

    if (hasSavedUser) {
      _loginFormKey.currentState?.setUsername(savedUser!.username);
    }
    if (widget.dni != null) {
      loginData.username = widget.dni;
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
                      initialDNI: widget.dni,
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
                                child: LocalizedText(
                                  'NOT_REGISTRED',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              )
                            : SizedBox(),
                        (!hasSavedUser) ? _registerButton() : SizedBox(),
                        _businessesLink(),
                      ],
                    ),
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
    return InkWell(
      onTap: _goToForgotPassword,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          alignment: Alignment.topRight,
          child: LocalizedText(
            'FORGOT_PASSWORD',
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
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());

    var appState = AppProvider.of(context, listen: false);
    loginData.version = appState.versionInt;

    await Loading.show();
    await loginService
        .login(loginData, platform: Platform.operatingSystem)
        .then(_onLoginSuccess)
        .catchError(_onLoginError);
  }

  dynamic _onLoginSuccess(response) {
    Loading.dismiss();

    if (widget.onLogin != null) return widget.onLogin!();

    Navigator.of(context).pushReplacementNamed(Routes.init);
  }

  dynamic _onLoginError(error) {
    Loading.dismiss();

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

    if (error.message == HandledErrors.maxAttempstExceeded) {
      RecToast.showError(context, 'MAX_ATTEMPTS_EXCEEDED');
    }

    if (error.message == HandledErrors.accountNotActive) {
      RecToast.showError(context, 'ACCOUNT_NOT_ACTIVE');
    }

    RecToast.showError(context, error.message);
  }

  _businessesLink() {
    if (env.PROJECT_NAME != 'larosa') return SizedBox.shrink();

    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: WidgetLink(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: RecTheme.of(context)?.primaryColor),
            LocalizedText(
              'title.link_businesses',
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            )
          ],
        ),
        onTap: () {
          InAppBrowser.openLink(
            context,
            localizations!.translate('link_businesses'),
            title: localizations.translate('title.link_businesses'),
          );
        },
      ),
    );
  }
}
