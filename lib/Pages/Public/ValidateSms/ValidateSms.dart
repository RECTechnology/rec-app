import 'package:flutter/material.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/PhoneVerificationService.dart';
import 'package:rec/Api/Services/SMSService.dart';

import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Helpers/RecToast.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';

class ValidateSms extends StatefulWidget {
  final String phone;
  final String dni;

  ValidateSms(
    this.phone,
    this.dni,
  );

  @override
  _ValidateSmsState createState() => _ValidateSmsState();
}

class _ValidateSmsState extends State<ValidateSms> {
  final _formKey = GlobalKey<FormState>();
  final smsService = SMSService();
  final validateSMS = PhoneVerificationService();

  String sms = '';
  bool smsSent = false;

  @override
  void initState() {
    super.initState();
    Auth.getAppToken().then((value) {
      smsService.sendSMS(phone: widget.phone, dni: widget.dni).then((value) {
        smsSent = true;
        RecToast.showInfo(context, 'SMS sent');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: EmptyAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: Paddings.page,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Text(
                    localizations.translate('SEND_SMS_U'),
                    style: TextStyles.pageTitle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  localizations.translate('HELP_US_VALIDATE_PHONE') + ' ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.phone,
                  style: TextStyle(
                    fontSize: 20,
                    color: Brand.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      child: RecTextField(
                        placeholder: '......',
                        needObscureText: false,
                        keyboardType: TextInputType.phone,
                        isPassword: false,
                        isNumeric: true,
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
                SizedBox(height: 48),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 24,
              left: 32,
              right: 32,
            ),
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

  void validatedOk(value) {
    var localizations = AppLocalizations.of(context);
    RecToast.show(context, localizations.translate('PHONE_VERIFY_OK'));
    Navigator.of(context).pop({
      'valid': true,
      'sms': sms,
    });
  }

  void validatedWithError(error) {
    var localizations = AppLocalizations.of(context);
    RecToast.showError(
      context,
      localizations.translate(error['body']['message']),
    );
  }

  void tryValidateSMS() {
    var localizations = AppLocalizations.of(context);

    if (_formKey.currentState.validate()) {
      //Hacer llamada a la API para validar sms
      validateSMS.validateSMSCode(code: sms, NIF: widget.dni).then((value) {
        RecToast.showInfo(context, localizations.translate('PHONE_VERIFY_OK'));
        Navigator.of(context).pop({
          'valid': true,
        });
      }).catchError((error) {
        RecToast.showError(
            context, localizations.translate(error['body']['message']));
      });
    } else {
      RecToast.show(
        context,
        localizations.translate('ERROR_CODE'),
      );
    }
  }

  void setSMS(String sms) {
    this.sms = sms;
  }
}
