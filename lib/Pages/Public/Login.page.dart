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
  _LoginPageState createState() => _LoginPageState(isLog);
}

class _LoginPageState extends GenericRecViewScreen<LoginPage> {
  bool isLogState;
<<<<<<< HEAD
  String dni = "53791396P";
  String contra = "";
  String userName = "Vicmi";
=======
  String dni = '53791396P';
  String password = '';
  String userName = 'Vicmi';

  LoginService loginService = LoginService();
>>>>>>> 0493584ea137e446088b473d2aad0a2083ecee0b

  _LoginPageState(this.isLogState);

  @override
  Widget buildPageContent(BuildContext context, AppState state) {
    return notLoged(context); //isLogState ? loged(context) : notLoged(context);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget notLoged(BuildContext context) {
<<<<<<< HEAD
    AppLocalizations localizations = AppLocalizations.of(context);

=======
    var localizations = AppLocalizations.of(context);
>>>>>>> 0493584ea137e446088b473d2aad0a2083ecee0b
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 45, 0, 20), //Left,Top,Right,Bottom
              child: Text(
                localizations.translate('HELLOU'),
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0), //Left,Top,Right,Bottom
              child: Text(
                localizations.translate('DONT_HAVE_ACCOUNT'),
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 70, 0), //Left,Top,Right,Bottom
              child: ButtonRec(
                  textColor: Colors.white,
                  backgroundColor: Colors.black,
<<<<<<< HEAD
                  onPressed: singIn,
=======
                  onPressed: login,
>>>>>>> 0493584ea137e446088b473d2aad0a2083ecee0b
                  text: Text(localizations.translate('REGISTER'))),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 30, 0), //Left,Top,Right,Bottom
              child: Text(
                localizations.translate('HAVE_ACCOUNT'),
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
            RecTextField(
              isNumeric: false,
              keyboardType: TextInputType.text,
              needObscureText: false,
              placeholder: localizations.translate('WRITE_DOCUMENT'),
              title: localizations.translate('DNI'),
<<<<<<< HEAD
              isPassword: true,
=======
              isPassword: false,
>>>>>>> 0493584ea137e446088b473d2aad0a2083ecee0b
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
                      Navigator.of(context).pushNamed('/registerOne');
                    },
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 300,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Text(
                localizations.translate('DONT_HAVE_ACCOUNT_2'),
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 70, 0),
              child: ButtonRec(
                textColor: Colors.white,
                backgroundColor: Colors.black,
<<<<<<< HEAD
                onPressed: singIn,
=======
                onPressed: login,
>>>>>>> 0493584ea137e446088b473d2aad0a2083ecee0b
                text: Text("LOGIN"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loged(BuildContext context) {
<<<<<<< HEAD
    AppLocalizations localizations = AppLocalizations.of(context);
=======
    var localizations = AppLocalizations.of(context);
>>>>>>> 0493584ea137e446088b473d2aad0a2083ecee0b
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: Text(
                localizations.translate('HELLOU') + " " + userName,
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
              child: Text(
                localizations.translate('INSERT_PASSWORD'),
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
<<<<<<< HEAD
              decoration: new BoxDecoration(color: Colors.white, boxShadow: [
                new BoxShadow(
                    color: Colors.black54,
                    offset: new Offset(0.0, 0.0),
                    blurRadius: 500.0)
              ]),
=======
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
>>>>>>> 0493584ea137e446088b473d2aad0a2083ecee0b
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
<<<<<<< HEAD
                          child: Text(
                            localizations.translate('ARE_NOT_U'),
                            style: TextStyle(fontSize: 15, color: Colors.blue),
=======
                          child: InkWell(
                            onTap: () => {},
                            child: Text(
                              localizations.translate('ARE_NOT_U'),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                              ),
                            ),
>>>>>>> 0493584ea137e446088b473d2aad0a2083ecee0b
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
            Container(
              margin: EdgeInsets.fromLTRB(60, 10, 60, 0),
              child: RecTextField(
                isNumeric: false,
                keyboardType: TextInputType.text,
                needObscureText: true,
                placeholder: localizations.translate('WRITE_PASSWORD'),
                title: localizations.translate('PASSWORD'),
                isPassword: true,
                function: setPassword,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 70, 0),
              child: ButtonRec(
                textColor: Colors.white,
                backgroundColor: Colors.black,
<<<<<<< HEAD
                onPressed: singIn,
=======
                onPressed: login,
>>>>>>> 0493584ea137e446088b473d2aad0a2083ecee0b
                text: Text(localizations.translate('LOGIN')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setDni(String dniTextField) {
    dni = dniTextField;
  }

  void setPassword(String passwordTextField) {
<<<<<<< HEAD
    contra = passwordTextField;
  }

  singIn() {
    Navigator.of(context).pushNamed('/registerOne');
=======
    password = passwordTextField;
  }

  login() {
    loginService
        .login(username: dni, password: password)
        .then(onLogin)
        .catchError(onError);
  }

  onLogin(response) {
    // Logged in OK
  }

  onError(error) {
    // Logged in with error
>>>>>>> 0493584ea137e446088b473d2aad0a2083ecee0b
  }
}
