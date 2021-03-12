import 'package:flutter/material.dart';
import 'package:rec/Components/ButtonRec.dart';

import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Lang/AppLocalizations.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.isLog);

  final bool isLog;

  @override
  _LoginPageState createState() => _LoginPageState(isLog);
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool isLogSatate;
  var dni = "";
  var contra = "";
  var obscureText = true;

  _LoginPageState(this.isLogSatate);


  @override
  Widget build(BuildContext context) {
    if (isLogSatate) {
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 45, 0, 20), //Left,Top,Right,Bottom
              child: Text(
                AppLocalizations.of(context).translate('HELLOU'),
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0), //Left,Top,Right,Bottom
              child: Text(
                AppLocalizations.of(context).translate('DONT_HAVE_ACCOUNT'),
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
            ButtonRec(
                textColor: Colors.white,
                backgroundColor: Colors.black,
                onPressed: singIn,
                text: Text(AppLocalizations.of(context).translate('REGISTER'))),
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 30, 0), //Left,Top,Right,Bottom
              child: Text(
                AppLocalizations.of(context).translate('HAVE_ACCOUNT'),
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
            RecTextField(
                helperText: "Skeleeeeeer",
                isNumeric: false,
                keyboardType: TextInputType.text,
                needObscureText: true,
                placeholder:
                    AppLocalizations.of(context).translate('WRITE_DOCUMENT'),
                title: AppLocalizations.of(context).translate('DNI'),
                isPassword: true),
            RecTextField(
                helperText: "Skeleeeer",
                isNumeric: false,
                keyboardType: TextInputType.text,
                needObscureText: true,
                placeholder:
                    AppLocalizations.of(context).translate('WRITE_PASSWORD'),
                title: AppLocalizations.of(context).translate('PASSWORD'),
                isPassword: true),
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 0), //Left,Top,Right,Bottom
              child: Text(
                AppLocalizations.of(context).translate('FORGOT_PASSWORD'),
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
            ButtonRec(
              textColor: Colors.white,
              backgroundColor: Colors.black,
              onPressed: singIn,
              text: Text("LOGIN"),
            )
            //LoadingButton(text: "log in",onPressed: singIn,isLoading: false,),
          ],
        ),
      ),
    );
  }
  Widget loged(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
  changeObscureText() {
    if (obscureText) {
      obscureText = false;
    } else {
      obscureText = true;
    }
    print("obscureText = " + obscureText.toString());
  }

  setDni() async {
    print(isLogSatate);
    print("entro a setear el dni");
  }

  singIn() async {}
}
