import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/brand.dart';

class RegisterOne extends StatefulWidget {
  @override
  RegisterOneState createState() => RegisterOneState();
}

class RegisterOneState extends GenericRecViewScreen<RegisterOne> {
  bool checkValue = false;
  String accountType = Account.TYPE_PRIVATE;

  bool get isAccountPrivate => accountType == Account.TYPE_PRIVATE;

  @override
  Widget buildPageContent(
    BuildContext context,
    AppState state,
    AppLocalizations localizations,
  ) {
    var currentColor = Brand.getColorForAccountType(accountType);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: currentColor,
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
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(80, 0, 0, 0),
          child: Row(
            children: [
              IconButtonRec(
                function: setToParticular,
                icon: Icon(Icons.phone),
              ),
              IconButtonRec(
                function: setToOrganizations,
                icon: Icon(Icons.phone),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                isAccountPrivate
                    ? localizations.translate('PROMOTE_TRADE')
                    : localizations.translate('TO_START_WRITE'),
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(20, 0, 0, 30),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: localizations.translate('CREATE_USER'),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: RecTextField(
                placeholder: localizations.translate('WRITE_DOCUMENT'),
                needObscureText: false,
                keyboardType: TextInputType.phone,
                isPassword: false,
                isNumeric: true,
                title: localizations.translate('DNI_NIE'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: RecTextField(
                placeholder: localizations.translate('PASSWORD'),
                needObscureText: false,
                keyboardType: TextInputType.phone,
                isPassword: false,
                isNumeric: true,
              ),
            ),
            isAccountPrivate
                ? Text('')
                : Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Text(
                      localizations.translate('PRESS_NEXT_TO_ADD'),
                      style: TextStyle(color: Colors.deepOrange, fontSize: 14),
                    ),
                  ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
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
                      text: localizations.translate('ACORD_WHIT_TEMS'),
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: ButtonRec(
                textColor: Colors.white,
                backgroundColor: currentColor,
                onPressed: setToParticular,
                text: Text(localizations.translate('NEXT')),
              ),
            )
          ],
        ),
      ),
    );
  }

  void setToParticular() {
    setAccountType(Account.TYPE_PRIVATE);
  }

  void setToOrganizations() {
    setAccountType(Account.TYPE_COMPANY);
  }

  void setAccountType(String type) {
    setState(() {
      accountType = type;
    });
  }
}
