import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rec/Api/Services/LoginService.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/LoggedInBeforeCard.dart';

import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Entities/User.ent.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends GenericRecViewScreen<LoginPage> {
  String dni = '';
  String password = '';
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
  Widget buildPageContent(
    BuildContext context,
    AppState state,
    UserState userState,
    AppLocalizations localizations,
  ) {
    var savedUser = userState.savedUser;
    var hasSavedUser = userState.hasSavedUser();

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
                      : RecTextField(
                          initialValue: dni,
                          isNumeric: false,
                          keyboardType: TextInputType.text,
                          needObscureText: false,
                          placeholder:
                              localizations.translate('WRITE_DOCUMENT'),
                          title: localizations.translate('DNI'),
                          isPassword: false,
                          function: setDni,
                          colorLine: Brand.primaryColor,
                          validator: (String string) {},
                          isPhone: false,
                          icon: Icon(Icons.account_circle),
                        ),
                  _passwordField(localizations),
                  _forgotPassLink(localizations),
                  _loginButton(localizations, userState),
                  (!hasSavedUser)
                      ? Container(
                          alignment: Alignment.center,
                          width: 300,
                          margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                          child: Text(
                            localizations.translate('NOT_REGISTRED'),
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        )
                      : SizedBox(),
                  (!hasSavedUser)
                      ? Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: ButtonRec(
                            textColor: Colors.white,
                            backgroundColor: Brand.primaryColor,
                            onPressed: singIn,
                            widthBox: 250,
                            isButtonDisabled: isDisabled,
                            widget: Icon(Icons.arrow_forward_ios),
                            text: localizations.translate('REGISTER'),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _passwordField(AppLocalizations localizations) {
    return Padding(
      padding: Paddings.textField,
      child: RecTextField(
        initialValue: password,
        isNumeric: false,
        keyboardType: TextInputType.text,
        needObscureText: true,
        placeholder: localizations.translate('WRITE_PASSWORD'),
        isPassword: false,
        function: setPassword,
        colorLine: Brand.primaryColor,
        validator: (String string) {},
        isPhone: false,
        icon: Icon(Icons.lock),
      ),
    );
  }

  Widget _forgotPassLink(AppLocalizations localizations) {
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

  Widget _loginButton(AppLocalizations localizations, UserState userState) {
    return Padding(
      padding: Paddings.button,
      child: ButtonRec(
        textColor: Colors.white,
        backgroundColor: Brand.primaryColor,
        onPressed: () => login(
          (userState.hasSavedUser() ? userState.savedUser.username : dni),
          password,
        ),
        widthBox: 370,
        isButtonDisabled: isDisabled,
        widget: Icon(Icons.arrow_forward_ios),
        text: localizations.translate('LOGIN'),
      ),
    );
  }

  Widget _header() {
    return Container(
      child: Image(
        image: AssetImage('assets/login-header.jpg'),
      ),
    );
  }

  void setDni(String dniTextField) {
    dni = dniTextField;
  }

  void setPassword(String passwordTextField) {
    password = passwordTextField;
  }

  void singIn() {
    Navigator.of(context).pushNamed(Routes.registerOne);
  }

  void login(dni, password) {
    setEnabled(false);
    loginService
        .login(username: dni, password: password)
        .then(onLogin)
        .catchError(onError);
  }

  void onLogin(response) {
    if (response['error_description'] == null) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else {
      setEnabled(true);
      onError(response['error_description']);
    }
  }

  void setEnabled(bool enabled) {
    setState(() => isDisabled = !enabled);
  }

  void onError(error) {
    setEnabled(true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        duration: const Duration(milliseconds: 1500),
        width: 300.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void onNotYou(UserState userState) async {
    await userState.unstoreUser();
  }
}
