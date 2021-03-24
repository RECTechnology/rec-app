import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Verify/VerifyDataRec.dart';


class RegisterTwo extends StatefulWidget {
  @override
  RegisterTwoState createState() => RegisterTwoState();
}

class RegisterTwoState extends GenericRecViewScreen<RegisterTwo> {
  String userName="";
  String CIF = "";
  String email= "";

  @override
  Widget buildPageContent(BuildContext context, AppState state) {
    Map parameters = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: AppBar(
            backgroundColor: Colors.orangeAccent,
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
              margin: EdgeInsets.fromLTRB(90, 0, 0, 0), //Left,Top,Right,Bottom
              child: Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    child: IconButton(
                      icon: Image.asset('assets/organization.png'),
                      onPressed: () {},
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
                AppLocalizations.of(context).translate('MAKE_KNOW'),
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(20, 0, 0, 30), //Left,Top,Right,Bottom
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: AppLocalizations.of(context).translate('ADD_ORG'),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15), //Left,Top,Right,Bottom

              child: RecTextField(
                needObscureText: false,
                keyboardType: TextInputType.text,
                isPassword: false,
                isNumeric: false,
                title: AppLocalizations.of(context).translate('NAME'),
                colorLine: Colors.orange,
                function: setUserName,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15), //Left,Top,Right,Bottom

              child: RecTextField(
                placeholder: AppLocalizations.of(context).translate('CIF'),
                needObscureText: false,
                keyboardType: TextInputType.text,
                isPassword: false,
                isNumeric: false,
                colorLine: Colors.orange,
                function: setCIF,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15), //Left,Top,Right,Bottom

              child: RecTextField(
                placeholder: AppLocalizations.of(context).translate('EMAIL'),
                needObscureText: false,
                keyboardType: TextInputType.text,
                isPassword: false,
                isNumeric: false,
                colorLine: Colors.orange,
                function: setEmail,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(20, 20, 0, 0), //Left,Top,Right,Bottom
              child: Text(
                AppLocalizations.of(context).translate('WHEN_INIT_SESION'),
                style: TextStyle(color: Colors.deepOrange, fontSize: 14),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
              //Left,Top,Right,Bottom
              child: ButtonRec(
                onPressed: Register,
                textColor: Colors.white,
                backgroundColor: Colors.deepOrange,
                text: Text(AppLocalizations.of(context).translate('REGISTER')),
              ),
            )
          ],
        ),
      ),
    );
  }

  void setUserName(String userName) {
    this.userName = userName;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setCIF(String CIF) {
    this.CIF = CIF;
  }
  void Register(){
    if (VerifyDataRec.validateCif(CIF)) {
      if(VerifyDataRec.validateEmail(email)){


      }else{
        printToastRec(AppLocalizations.of(context).translate('BAD_MAIL'));
      }
    }else{
      printToastRec(AppLocalizations.of(context).translate('BAD_CIF'));
    }
  }
  void printToastRec(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepOrange,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}
