import 'package:flutter/material.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/RecTextField.dart';

import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';

class RecoveryPassword extends StatefulWidget {
  RecoveryPassword();

  @override
  _RecoveryPasswordState createState() => _RecoveryPasswordState();
}

class _RecoveryPasswordState extends GenericRecViewScreen<RecoveryPassword> {
  @override
  Widget buildPageContent(BuildContext context, AppState state) {
    // TODO: implement buildPageContent
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('FORGOT_PASSWORD'),
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButtonRec(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          function: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 140, 0),
              child: Text(
                AppLocalizations.of(context).translate('FORGOT_PASSWORD'),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: RecTextField(
                title: AppLocalizations.of(context).translate('DOCUMENT_DATA'),
                isNumeric: false,
                isPassword: false,
                keyboardType: TextInputType.text,
                needObscureText: false,
                placeholder:
                    AppLocalizations.of(context).translate('WRITE_DOCUMENT'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: RecTextField(
                title: AppLocalizations.of(context).translate('TELF'),
                isNumeric: false,
                isPassword: false,
                keyboardType: TextInputType.text,
                needObscureText: false,
                placeholder:
                    AppLocalizations.of(context).translate('WRITE_TELF'),
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                //Left,Top,Right,Bottom
                //Left,Top,Right,Bottom
                child: ButtonRec(
                  textColor: Colors.black,
                  backgroundColor: Colors.white,
                  onPressed: changePassword,
                  text: Text("LOGIN"),
                )),
          ],
        ),
      ),
    );
  }

  void changePassword() {}
}
