import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:country_code_picker/country_code_picker.dart';

class RegisterOne extends StatefulWidget {
  @override
  RegisterOneState createState() => RegisterOneState();
}

class RegisterOneState extends GenericRecViewScreen<RegisterOne> {
  var isParticular = true;
  bool checkValue = false;
  String prefix = "+34";
  String telephone = "";
  String idDocument = "";
  String password = "";

  @override
  Widget buildPageContent(BuildContext context, AppState state) {
    // TODO: implement buildPageContent
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
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
              margin: EdgeInsets.fromLTRB(20, 0, 0, 10), //Left,Top,Right,Bottom
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: AppLocalizations.of(context).translate('CREATE_USER'),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0), //Left,Top,Right,Bottom
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    //Left,Top,Right,Bottom
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: AppLocalizations.of(context).translate('TELF'),
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        child: CountryCodePicker(
                          onChanged: setPrefix,
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: 'ES',
                          favorite: ['+34', 'ES'],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        //Left,Top,Right,Bottom
                        height: 100,
                        width: 280,
                        child: RecTextField(
                          needObscureText: false,
                          keyboardType: TextInputType.phone,
                          isPassword: false,
                          isNumeric: true,
                          icon: Icon(Icons.phone),
                          colorLine:
                              isParticular ? Colors.blueAccent : Colors.orange,
                          function: setPhone,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15), //Left,Top,Right,Bottom

              child: RecTextField(
                placeholder: AppLocalizations.of(context).translate('DNI/NIE'),
                needObscureText: false,
                keyboardType: TextInputType.text,
                isPassword: false,
                isNumeric: false,
                icon: Icon(Icons.account_circle),
                colorLine: isParticular ? Colors.blueAccent : Colors.orange,
                function: setIdDocument,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15), //Left,Top,Right,Bottom

              child: RecTextField(
                placeholder: AppLocalizations.of(context).translate('PASSWORD'),
                needObscureText: true,
                keyboardType: TextInputType.text,
                isPassword: false,
                isNumeric: false,
                icon: Icon(Icons.lock),
                colorLine: isParticular ? Colors.blueAccent : Colors.orange,
                function: setPassword,
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
              child: isParticular ? const SizedBox(height: 20) : null,
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

  void setPhone(String phone) {
    telephone = phone;
  }

  void setPrefix(CountryCode prefix) {
    this.prefix = prefix.toString();
  }

  void setIdDocument(String document) {
    idDocument = document;
  }



  void setPassword(String password) {
    this.password = password;
  }

  void next() {
    if (phoneVerification(prefix.toString(), telephone)) {
      if (verifyIdentityDocument(idDocument)) {
        if (passwordVerifycation(this.password)) {
          if (checkValue) {
            if (isParticular) {}
            if (isParticular == false) {
              Navigator.of(context).pushNamed('/registerTwo');
            }
          }
        }
      }
    }
  }

  void setTipeScreen(bool tipe) {
    setState(() {
      isParticular = tipe;
    });
  }

  bool passwordVerifycation(String password) {
    if (password.length >= 6) {
      return true;
    } else {
      return false;
    }
  }

  bool phoneVerification(String prefix, String phone) {

    if (prefix == "+34") {
      if (phone.length == 9) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool verifyIdentityDocument(String document) {
    var DNI_REGEX = new RegExp(r"^(\d{8})([A-Z])$", caseSensitive: false);
    var NIE_REGEX = new RegExp(r"^[XYZ]\d{7,8}[A-Z]$");
    if (DNI_REGEX.hasMatch(document)) {
      return true;
    } else {
      if (NIE_REGEX.hasMatch(document)) {
        return true;
      } else {
        return false;
      }
    }
  }
}


