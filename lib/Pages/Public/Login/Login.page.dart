import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rec/Api/Services/LoginService.dart';
import 'package:rec/Components/LoggedInBeforeCard.dart';
import 'package:rec/Components/RecActionButton.dart';

import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Components/RecToast.dart';
import 'package:rec/Entities/User.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String dni;
  String password;
  String userName = '';
  User savedUser;

  LoginService loginService = LoginService();
  bool isDisabled = false;

  _LoginPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var localizations = AppLocalizations.of(context);
    var savedUser = userState.savedUser;
    var hasSavedUser = userState.hasSavedUser();

    if (hasSavedUser) {
      setDni(savedUser.username);
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
                  hasSavedUser
                      ? LoggedInBeforeCard(
                          savedUser: savedUser,
                          onNotYou: () => onNotYou(userState),
                        )
                      : _dniField(),
                  _passwordField(),
                  _forgotPassLink(),
                  _loginButton(),
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

  Widget _dniField() {
    var localizations = AppLocalizations.of(context);
    return RecTextField(
      label: 'DNI',
      initialValue: dni,
      isNumeric: false,
      keyboardType: TextInputType.text,
      needObscureText: false,
      placeholder: localizations.translate('WRITE_DOCUMENT'),
      isPassword: false,
      onChange: setDni,
      colorLine: Brand.primaryColor,
      validator: (String string) {},
      isPhone: false,
      icon: Icon(
        Icons.account_circle,
        color: Brand.grayIcon,
      ),
    );
  }

  Widget _passwordField() {
    var localizations = AppLocalizations.of(context);
    return Padding(
      padding: Paddings.textField,
      child: RecTextField(
        label: localizations.translate('PASSWORD'),
        initialValue: password,
        isNumeric: false,
        keyboardType: TextInputType.text,
        needObscureText: true,
        placeholder: localizations.translate('WRITE_PASSWORD'),
        isPassword: false,
        onChange: setPassword,
        colorLine: Brand.primaryColor,
        validator: (String string) {},
        isPhone: false,
        icon: Icon(
          Icons.lock,
          color: Brand.grayIcon,
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
          style: TextStyle(color: Brand.primaryColor),
          text: localizations.translate('FORGOT_PASSWORD'),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              await Navigator.of(context).pushNamed('/recoveryPassword');
            },
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      width: 250,
      child: RecActionButton(
          label: 'REGISTER',
          onPressed: registerButtonPressed,
          icon: Icons.arrow_forward_ios,
          padding: EdgeInsets.all(0)),
    );
  }

  Widget _loginButton() {
    return RecActionButton(
      label: 'LOGIN',
      disabled: (dni == null || dni.isEmpty) ||
          (password == null || password.isEmpty),
      onPressed: loginButtonPressed,
      icon: Icons.arrow_forward_ios,
    );
  }

  Widget _header() {
    return Container(
      child: Image(image: AssetImage('assets/login-header.jpg')),
    );
  }

  void setDni(String newValue) {
    setState(() => dni = newValue);
  }

  void setPassword(String newValue) {
    setState(() => password = newValue);
  }

  void registerButtonPressed() {
    Navigator.of(context).pushNamed(Routes.registerOne);
  }

  void loginButtonPressed() async {
    setEnabled(false);

    await EasyLoading.show(status: 'Loading');

    await loginService
        .login(username: dni, password: password)
        .then(onLoginSuccess)
        .catchError(onLoginError);

    setEnabled(true);
    await EasyLoading.dismiss();
  }

  void onLoginSuccess(response) {
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  void onLoginError(error) {
    RecToast.show(context, error['body']['error_description']);
  }

  void setEnabled(bool enabled) {
    setState(() => isDisabled = !enabled);
  }

  void onNotYou(UserState userState) async {
    await userState.unstoreUser();
  }
}
