import 'package:flutter/material.dart';
import 'package:rec/Api/Services/PhoneVerificationService.dart';
import 'package:rec/Api/Services/SMSService.dart';

import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/TitleText.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class SmsCode extends StatefulWidget {
  final String phone;
  final String dni;
  final Function(String code) onCode;

  SmsCode({
    @required this.phone,
    @required this.dni,
    @required this.onCode,
  });

  @override
  _SmsCodeState createState() => _SmsCodeState();
}

class _SmsCodeState extends State<SmsCode> {
  final _formKey = GlobalKey<FormState>();
  final smsService = SMSService();
  final validateSMS = PhoneVerificationService();

  String sms = '';

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: EmptyAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: Paddings.pageNoTop,
            child: Column(
              children: [
                TitleText(
                  'SEND_SMS_U',
                  alignment: MainAxisAlignment.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    localizations.translate('HELP_US_VALIDATE_PHONE') + ' ',
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  widget.phone,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: Brand.primaryColor),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      child: RecTextField(
                        autofocus: true,
                        placeholder: '......',
                        needObscureText: false,
                        keyboardType: TextInputType.number,
                        isPassword: false,
                        isNumeric: false,
                        textSize: 20,
                        letterSpicing: 25,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        colorLine: Brand.primaryColor,
                        onChange: setSMS,
                        isPhone: false,
                        validator: Validators.smsCode,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: Paddings.pageNoTop,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RecActionButton(
                label: localizations.translate('VALIDATE'),
                backgroundColor: Brand.primaryColor,
                onPressed: tryValidateSMS,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void tryValidateSMS() {
    if (!_formKey.currentState.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());
    if (widget.onCode != null) widget.onCode(sms);
  }

  void setSMS(String sms) {
    this.sms = sms;
  }
}
