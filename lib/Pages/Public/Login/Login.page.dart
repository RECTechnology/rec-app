import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rec/Components/Forms/Login.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/RecHeader.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/map.page.dart';
import 'package:rec/Pages/Public/forgot_password.dart';
import 'package:rec/Pages/Public/MustUpdate.dart';
import 'package:rec/Pages/Public/validate_phone.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/app_provider.dart';
import 'package:rec/providers/campaign_provider.dart';
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
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final appProvider = AppProvider.of(context, listen: false);
      final campaignProvider = CampaignProvider.of(context, listen: false);

      appProvider.loadConfigurationSettings();
      campaignProvider.load();
    });
    super.initState();
  }

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
      resizeToAvoidBottomInset: false,
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
                    SizedBox(height: 24),
                    (!hasSavedUser) ? _registerButton() : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          _businessesLink(),
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
    return RecActionButton(
      label: 'REGISTER',
      onPressed: _registerButtonPressed,
      padding: EdgeInsets.all(0),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16),
      child: RecActionButton(
        label: 'BUSINESS_NETWORK',
        leading: Icons.location_on,
        backgroundColor: RecTheme.of(context)!.accentColor,
        onPressed: () {
          RecNavigation.navigate(
            context,
            (context) => MapPage(
              showAppBar: true,
            ),
          );
        },
      ),
    );
  }
}
