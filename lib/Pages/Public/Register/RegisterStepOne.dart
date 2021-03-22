import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';

class RegisterOne extends StatefulWidget {
  @override
  RegisterOneState createState() => RegisterOneState();
}

class RegisterOneState extends GenericRecViewScreen<RegisterOne> {
  var isParticular = true;
  bool checkValue = false;

  @override
  Widget buildPageContent(BuildContext context, AppState state) {
    // TODO: implement buildPageContent
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
            backgroundColor:
                isParticular ? Colors.lightBlueAccent : Colors.orangeAccent,
            leading: IconButtonRec(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              function: () {
                Navigator.of(context).pop();
              },
            ),
            title: Container(
              margin: EdgeInsets.fromLTRB(30, 20, 0, 0), //Left,Top,Right,Bottom
              child: Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    child: IconButton(
                      icon: isParticular
                          ? Image.asset('assets/avatar.png')
                          : Image.asset('assets/avatar-bw.png'),
                      onPressed: setToParticular,
                    ),
                  ),
                  Container(
                    width: 75,
                    height: 75,
                    child: IconButton(
                      icon: isParticular
                          ? Image.asset('assets/organization-bw.png')
                          : Image.asset('assets/organization.png'),
                      onPressed: setToOrganizations,
                    ),
                  ),
                ],
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(20, 20, 0, 0), //Left,Top,Right,Bottom
              child: Text(
                isParticular
                    ? AppLocalizations.of(context).translate('PROMOTE_TRADE')
                    : AppLocalizations.of(context).translate('TO_START_WRITE'),
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(20, 0, 0, 30), //Left,Top,Right,Bottom
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: AppLocalizations.of(context).translate('CREATE_USER'),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15), //Left,Top,Right,Bottom

              child: RecTextField(
                placeholder:
                    AppLocalizations.of(context).translate('WRITE_DOCUMENT'),
                needObscureText: false,
                keyboardType: TextInputType.phone,
                isPassword: false,
                isNumeric: true,
                title: AppLocalizations.of(context).translate('DNI_NIE'),
                colorLine: isParticular ? Colors.blueAccent : Colors.orange,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15), //Left,Top,Right,Bottom

              child: RecTextField(
                placeholder: AppLocalizations.of(context).translate('PASSWORD'),
                needObscureText: false,
                keyboardType: TextInputType.phone,
                isPassword: false,
                isNumeric: true,
                colorLine: isParticular ? Colors.blueAccent : Colors.orange,
              ),
            ),
            isParticular
                ? Text("")
                : Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(
                        20, 20, 0, 0), //Left,Top,Right,Bottom
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('PRESS_NEXT_TO_ADD'),
                      style: TextStyle(color: Colors.deepOrange, fontSize: 14),
                    ),
                  ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 10, 0, 0), //Left,Top,Right,Bottom
              child: Row(
                children: [
                  Checkbox(
                    value: checkValue,
                    onChanged: (bool value) {
                      setState(() {
                        checkValue = value;
                        print(value);
                      });
                    },
                  ),
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: AppLocalizations.of(context)
                          .translate('ACORD_WHIT_TEMS'),
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
              //Left,Top,Right,Bottom
              child: ButtonRec(
                textColor: Colors.white,
                backgroundColor:
                    isParticular ? Colors.blueAccent : Colors.deepOrange,
                onPressed: next,
                text: Text(AppLocalizations.of(context).translate('NEXT')),
              ),
            )
          ],
        ),
      ),
    );
  }

  void setToParticular() {
    setTipeScreen(true);
  }

  void setToOrganizations() {
    setTipeScreen(false);
  }

  void next() {
    if (isParticular) {}
    if (isParticular == false) {
      Navigator.of(context).pushNamed('/registerTwo');
    }
  }

  void setTipeScreen(bool tipe) {
    setState(() {
      isParticular = tipe;
    });
  }
}
