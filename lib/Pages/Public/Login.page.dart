import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rec/Api/Services/LoginService.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';

import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.isLog);

  final bool isLog;

  @override
  _LoginPageState createState() => _LoginPageState(false);
}

class _LoginPageState extends GenericRecViewScreen<LoginPage> {
  bool isLogState;
  String dni = '53791396P';
  String password = '';
  String userName = 'Vicmi';

  LoginService loginService = LoginService();

  _LoginPageState(this.isLogState);

  @override
  Widget buildPageContent(
    BuildContext context,
    AppState state,
    AppLocalizations localizations,
  ) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 55),
          child: Column(
            children: isLogState
                ? loggedInBefore(context, localizations)
                : notLoggedInBefore(context, localizations),
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(70, 0, 70, 0),
      child: ButtonRec(
        textColor: Colors.white,
        backgroundColor: Colors.black,
        onPressed: login,
        text: Text('LOGIN'),
      ),
    );
  }

  List<Widget> notLoggedInBefore(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return <Widget>[
      Text(
        localizations.translate('HELLOU'),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.blue),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          localizations.translate('DONT_HAVE_ACCOUNT'),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(70, 0, 70, 0),
        child: ButtonRec(
          textColor: Colors.white,
          backgroundColor: Colors.black,
          onPressed: login,
          text: Text(
            localizations.translate('REGISTER'),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(0, 15, 30, 15),
        child: Text(
          localizations.translate('HAVE_ACCOUNT'),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      RecTextField(
        isNumeric: false,
        keyboardType: TextInputType.text,
        needObscureText: false,
        placeholder: localizations.translate('WRITE_DOCUMENT'),
        title: localizations.translate('DNI'),
        isPassword: false,
        function: setDni,
      ),
      RecTextField(
        isNumeric: false,
        keyboardType: TextInputType.text,
        needObscureText: true,
        placeholder: localizations.translate('WRITE_PASSWORD'),
        title: localizations.translate('PASSWORD'),
        isPassword: true,
        function: setPassword,
      ),
      Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
        alignment: Alignment.topLeft,
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.blue),
            text: localizations.translate('FORGOT_PASSWORD'),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await Navigator.of(context).pushNamed('/registerOne');
              },
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        width: 300,
        margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Text(
          localizations.translate('DONT_HAVE_ACCOUNT_2'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      _loginButton(),
    ];
  }

  List<Widget> loggedInBefore(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return <Widget>[
      Text(
        '${localizations.translate('HELLOU')} $userName',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.blue),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          localizations.translate('INSERT_PASSWORD'),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 0.0),
              blurRadius: 20.0,
            )
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/userIcon.png'),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 0, 20),
                    child: InkWell(
                      onTap: () => {},
                      child: Text(
                        localizations.translate('ARE_NOT_U'),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      userName,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 110, 30),
                    child: Text(
                      dni,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      RecTextField(
        isNumeric: false,
        keyboardType: TextInputType.text,
        needObscureText: true,
        placeholder: localizations.translate('WRITE_PASSWORD'),
        title: localizations.translate('PASSWORD'),
        isPassword: true,
        function: setPassword,
      ),
      _loginButton(),
    ];
  }

  void setDni(String dniTextField) {
    dni = dniTextField;
  }

  void setPassword(String passwordTextField) {
    password = passwordTextField;
  }

  void login() {
    loginService
        .login(username: dni, password: password)
        .then(onLogin)
        .catchError(onError);
  }

  void onLogin(response) {
    // Logged in OK
  }

  void onError(error) {
    // Logged in with error
  }
}
