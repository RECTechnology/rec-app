import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Components/RecToast.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Helpers/VerifyDataRec.dart';
import 'package:rec/brand.dart';

class SendSMSPage extends StatefulWidget {
  @override
  _SendSMSPageState createState() => _SendSMSPageState();
}

class _SendSMSPageState extends State<SendSMSPage> {
  final _formKey = GlobalKey<FormState>();

  Timer _timer;
  int _start = 60;
  String sms = '';
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> data = ModalRoute.of(context).settings.arguments;
    var localizations = AppLocalizations.of(context);

    var phone = data['phone'];
    var isChangePassword = data['isChangePassword'];

    void sendedSMS() {
      if (_formKey.currentState.validate()) {
        isChangePassword == 'yes'
            ? Navigator.of(context).pushNamed('/changePassword', arguments: sms)
            : Navigator.of(context).pushNamed('/login', arguments: sms);
      } else {
        RecToast.show(
          context,
          localizations.translate('ERROR_CODE'),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
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
              margin: EdgeInsets.fromLTRB(32, 57, 32, 0),
              child: Text(
                localizations.translate('HELP_US_VALIDATE_PHONE') + ' ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 39),
              child: Text(
                phone,
                style: TextStyle(
                  fontSize: 20,
                  color: Brand.primaryColor,
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
                  colorLine: Brand.primaryColor,
                  onChange: setSMS,
                  isPhone: false,
                  validator: VerifyDataRec.verifySMS,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 44, 0, 0),
              child: Text(
                _start.toString(),
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(20, 159, 20, 0),
                child: ButtonRec(
                  textColor: Colors.white,
                  backgroundColor: Brand.primaryColor,
                  onPressed: sendedSMS,
                  widthBox: 370,
                  isButtonDisabled: false,
                  widget: Icon(Icons.arrow_forward_ios),
                  text: localizations.translate('NEXT'),
                )),
          ],
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void setSMS(String sms) {
    this.sms = sms;
  }
}
