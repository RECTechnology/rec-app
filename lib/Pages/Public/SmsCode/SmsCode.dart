import 'package:flutter/material.dart';
import 'package:rec/Api/Services/public/PhoneVerificationService.dart';
import 'package:rec/Api/Services/public/PublicSMSService.dart';

import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/RecPinInput.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/TitleText.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class SmsCode extends StatefulWidget {
  final String prefix;
  final String phone;
  final String dni;
  final Function(String code) onCode;

  SmsCode({
    @required this.phone,
    @required this.dni,
    @required this.onCode,
    @required this.prefix,
  });

  @override
  _SmsCodeState createState() => _SmsCodeState();
}

class _SmsCodeState extends State<SmsCode> {
  final smsService = PublicSMSService();
  final validateSMS = PhoneVerificationService();

  String smsCode = '';

  bool get isFormValid => smsCode.isNotEmpty && smsCode.length == 6;

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: EmptyAppBar(context),
      body: Padding(
        padding: Paddings.pageNoTop,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 32,
                ),
                child: RecPinInput(
                  fieldsCount: 6,
                  onChanged: setSMS,
                  autofocus: true,
                ),
              ),
            ]),
            RecActionButton(
              label: localizations.translate('VALIDATE'),
              backgroundColor: Brand.primaryColor,
              onPressed: isFormValid ? _tryValidateSMS : null,
            ),
          ],
        ),
      ),
    );
  }

  void _tryValidateSMS() {
    if (!isFormValid) return;

    FocusScope.of(context).requestFocus(FocusNode());
    if (widget.onCode != null) widget.onCode(smsCode);
  }

  void setSMS(String smsCode) {
    setState(() => this.smsCode = smsCode);
  }
}
