import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rec/Api/Services/PhoneVerificationService.dart';
import 'package:rec/Api/Services/SMSService.dart';
import 'package:rec/Components/Forms/DniPhone.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Public/SmsCode/SmsCode.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class ValidatePhone extends StatefulWidget {
  final String dni;
  ValidatePhone({this.dni = ''});

  @override
  _ValidatePhoneState createState() => _ValidatePhoneState();
}

class _ValidatePhoneState extends State<ValidatePhone> {
  final _formKey = GlobalKey<FormState>();
  final validateSMS = PhoneVerificationService();
  final smsService = SMSService();

  DniPhoneData data = DniPhoneData(prefix: '+34');

  @override
  void initState() {
    super.initState();
    data.dni = widget.dni;
  }

  bool get isFormValid {
    return data.complete();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: EmptyAppBar(context),
        body: Padding(
          padding: Paddings.pageNoTop,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topTexts(),
                  _validatePhoneForm(),
                ],
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
                    label: localizations.translate('NEXT'),
                    backgroundColor: Brand.primaryColor,
                    icon: Icons.arrow_forward_ios_sharp,
                    onPressed: isFormValid ? _next : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topTexts() {
    return Column(
      children: [
        TitleText('PHONE_NOT_VALIDATED'),
        SizedBox(height: 16),
        CaptionText('VALIDATE_PHONE'),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _validatePhoneForm() {
    return DniPhoneForm(
      formKey: _formKey,
      data: data,
      onChange: (data) {
        this.data = data;
      },
    );
  }

  void _next() async {
    if (!_formKey.currentState.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());

    await Loading.show();
    await _sendSmsCode()
        .then((value) => _goToEnterSmsCode())
        .catchError(_onError);
  }

  Future<void> _sendSmsCode() {
    return smsService.sendValidatePhoneSms(
      phone: data.phone,
      prefix: data.prefix,
    );
  }

  Future<void> _goToEnterSmsCode() async {
    await Loading.dismiss();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => SmsCode(
          prefix: data.prefix,
          phone: data.phone,
          dni: data.dni,
          onCode: _validateSmsCode,
        ),
      ),
    );
  }

  void _validateSmsCode(String smsCode) {
    EasyLoading.show();
    validateSMS
        .validatePhone(
          smscode: smsCode,
          dni: data.dni,
          prefix: data.prefix,
          phone: data.phone,
        )
        .then(_validateOk)
        .catchError(_onError);
  }

  void _validateOk(value) {
    Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
    RecToast.showSuccess(context, 'PHONE_VALIDATED_OK');
    EasyLoading.dismiss();
  }

  void _onError(error) {
    var localizations = AppLocalizations.of(context);
    EasyLoading.dismiss();
    RecToast.showError(
      context,
      localizations.translate(error.message),
    );
  }
}
