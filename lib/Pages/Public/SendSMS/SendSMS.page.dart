import 'package:flutter/material.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Components/ToastRec.dart';

import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Verify/VerifyDataRec.dart';

class SendSMSPage extends StatefulWidget {
  SendSMSPage();

  @override
  _SendSMSPageState createState() => _SendSMSPageState();
}

class _SendSMSPageState extends GenericRecViewScreen<SendSMSPage> {
  final _formKey = GlobalKey<FormState>();

  String phone = '610992764';
  String sms = '';

  @override
  Widget buildPageContent(
    BuildContext context,
    AppState state,
    UserState userState,
    AppLocalizations localizations,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButtonRec(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(32, 20, 32, 0),
              child: Text(
                localizations.translate('SEND_SMS_U'),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(32, 57, 32, 39),
              child: Text(
                localizations.translate('HELP_US_VALIDATE_PHONE') + ' ' + phone,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.fromLTRB(48, 0, 19, 0),
                child: RecTextField(
                  placeholder: '613335',
                  needObscureText: false,
                  keyboardType: TextInputType.phone,
                  isPassword: false,
                  isNumeric: true,
                  textSize: 20,
                  letterSpicing: 25,
                  textAlign: TextAlign.center,
                  colorLine: Colors.blueAccent,
                  function: setSMS,
                  isPhone: false,
                  validator: VerifyDataRec.verifySMS,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 203, 0, 0),
              width: 296,
              height: 48,
              child: ButtonRec(
                textColor: Colors.white,
                backgroundColor: Colors.blue,
                onPressed: sendSMS,
                widthBox: 370,
                isButtonDisabled: false,
                widget: Icon(Icons.arrow_forward_ios),
                text: localizations.translate('NEXT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendSMS() {
    var localization = AppLocalizations.of(context);
    var toastRec = ToastRec();
    if (_formKey.currentState.validate()) {
      return;
    } else {
      toastRec.printToastRec(localization.translate('ERROR_CODE'), context);
    }
  }

  void setSMS(String sms) {
    this.sms = sms;
  }
}
