import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/CircleAvatar.dart';

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
  String dni = "53791396P";
  String contra = "";
  String userName = "Vicmi";

  _LoginPageState(this.isLogState);

  @override
  Widget buildPageContent(BuildContext context, AppState state) {
    if (isLogState) {
      return loged(context);
    } else {
      return notLoged(context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget notLoged(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 40), //Left,Top,Right,Bottom
              child: Image(
                image: AssetImage('assets/BolasRec.PNG'),
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
              colorLine: Colors.blue,
              validator: (String string) {},
              isPhone: false,
              icon: Icon(Icons.account_circle),
            ),
            RecTextField(
              isNumeric: false,
              keyboardType: TextInputType.text,
              needObscureText: true,
              placeholder: localizations.translate('WRITE_PASSWORD'),
              isPassword: false,
              function: setPassword,
              colorLine: Colors.blue,
              validator: (String string) {},
              isPhone: false,
              icon: Icon(Icons.lock),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
              alignment: Alignment.topRight,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.blue),
                  text: localizations.translate('FORGOT_PASSWORD'),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      Navigator.of(context).pushNamed('/recoveryPassword');
                    },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ButtonRec(
                textColor: Colors.white,
                backgroundColor: Colors.blue,
                onPressed: singIn,
                widthBox: 370,
                widget: Icon(Icons.arrow_forward_ios),
                text: Text(localizations.translate('LOGIN')),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 300,
              margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: Text(
                localizations.translate('NOT_REGISTRED'),
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ButtonRec(
                textColor: Colors.white,
                backgroundColor: Colors.blue,
                onPressed: singIn,
                widthBox: 250,
                widget: Icon(Icons.arrow_forward_ios),
                text: Text(localizations.translate('REGISTER')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loged(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 40), //Left,Top,Right,Bottom
              child: Image(
                image: AssetImage('assets/BolasRec.PNG'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
              decoration: new BoxDecoration(color: Colors.white, boxShadow: [
                new BoxShadow(
                    color: Colors.black54,
                    offset: new Offset(0.0, 0.0),
                    blurRadius: 500.0)
              ]),
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          child: CircleAvatarRec(imageUrl: 'https://picsum.photos/250?image=9',),
                        ),

                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
                          alignment: Alignment.topRight,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.blue),
                              text: localizations.translate('ARE_NOT_U'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  Navigator.of(context).pushNamed('/registerTwo');
                                },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),

                    child: Column(

                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 140, 0),
                          alignment: Alignment.centerLeft,
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
              isPassword: false,
              function: setPassword,
              colorLine: Colors.blue,
              validator: (String string){},
              isPhone: false,
              icon: Icon(Icons.lock),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 40),
              alignment: Alignment.topRight,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.blue),
                  text: localizations.translate('FORGOT_PASSWORD'),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      Navigator.of(context).pushNamed('/recoveryPassword');
                    },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ButtonRec(
                textColor: Colors.white,
                backgroundColor: Colors.blue,
                onPressed: singIn,
                widthBox: 380,
                text: Text(localizations.translate('LOGIN')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setDni(String dniTextField) {
    this.dni = dniTextField;
  }

  void setPassword(String passwordTextField) {
    this.contra = passwordTextField;
  }

  singIn() {
    Navigator.of(context).pushNamed('/registerOne');
  }
}
