import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:rec/Verify/VerifyDataRec.dart';

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
  Map<String, String> data;

  @override
  Widget buildPageContent(BuildContext context, AppState state) {
    // TODO: implement buildPageContent
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130.0),
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
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    //Left,Top,Right,Bottom
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: AppLocalizations.of(context)
                            .translate('CREATE_USER'),
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      //Left,Top,Right,Bottom
                      child: isParticular
                          ? null
                          : IconButtonRec(
                              icon: Icon(Icons.announcement_outlined,color: Colors.deepOrange,),
                              function: () {
                                printToastRec(AppLocalizations.of(context)
                                    .translate('INTRODUCE_INFO'),12);
                              },
                            ))
                ],
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
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0), //Left,Top,Right,Bottom

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
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0), //Left,Top,Right,Bottom

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
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0), //Left,Top,Right,Bottom
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
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
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

  void createMapRec() {
    data = {
      'prefix': prefix,
      'phone': telephone,
      'idDocument': idDocument,
      'password': password,
    };
  }

  void setPassword(String password) {
    this.password = password;
  }

  void next() {
    if (VerifyDataRec.phoneVerification(prefix.toString(), telephone)) {
      if (VerifyDataRec.verifyIdentityDocument(idDocument)) {
        if (VerifyDataRec.passwordVerifycation(this.password)) {
          if (checkValue) {
            if (isParticular) {}
            if (isParticular == false) {
              createMapRec();
              Navigator.of(context).pushNamed('/registerTwo', arguments: data);
            }
          }
        } else {
          printToastRec(AppLocalizations.of(context).translate('BAD_PASSWORD'),14.0);
        }
      } else {
        printToastRec(
            AppLocalizations.of(context).translate('BAD_ID_DOCUMENT'),14.0);
      }
    } else {
      printToastRec(AppLocalizations.of(context).translate('BAD_PHONE'),14.0);
    }
  }

  void printToastRec(String msg,double fontSize) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepOrange,
        textColor: Colors.white,
        fontSize: fontSize);
  }

  void setTipeScreen(bool tipe) {
    setState(() {
      isParticular = tipe;
    });
  }
}
