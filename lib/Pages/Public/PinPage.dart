import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';

class PinPage extends StatefulWidget {
  @override
  PinPageState createState() => PinPageState();
}

class PinPageState extends GenericRecViewScreen<PinPage> {
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
              margin: EdgeInsets.fromLTRB(0, 45, 0, 30), //Left,Top,Right,Bottom
              child: Text(
                AppLocalizations.of(context).translate('SECURE_YOUR_ACCOUNT'),
                style: TextStyle(color: Colors.blue,fontSize: 30),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 30), //Left,Top,Right,Bottom

              child: RecTextField(
                placeholder:
                    AppLocalizations.of(context).translate('PIN_CODE'),
                needObscureText: false,
                keyboardType: TextInputType.phone,
                isPassword: false,
                isNumeric: true,
                title:
                    AppLocalizations.of(context).translate('PIN_CODE'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15), //Left,Top,Right,Bottom

              child: RecTextField(
                placeholder:
                    AppLocalizations.of(context).translate('RETURN_WRITE_PIN'),
                needObscureText: false,
                keyboardType: TextInputType.phone,
                isPassword: false,
                isNumeric: true,
                title:
                    AppLocalizations.of(context).translate('REPEAT_PIN_CODE'),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 90, 0), //Left,Top,Right,Bottom

                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        IconButtonRec(
                          icon: Icon(Icons.arrow_left),
                          function: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/recoveryPassword');
                          },
                        ),
                        Text(
                          AppLocalizations.of(context).translate('BACK'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(90, 0, 0, 0), //Left,Top,Right,Bottom
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context).translate('NEXT'),
                              ),
                              IconButtonRec(
                                icon: Icon(Icons.arrow_right),
                                function: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      '/recoveryPassword');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
