import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/PhoneVerificationService.dart';
import 'package:rec/Api/Services/SMSService.dart';
import 'package:rec/Components/Forms/DniPhone.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
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

  DniPhoneData data = DniPhoneData();

  @override
  void initState() {
    super.initState();
    data.dni = widget.dni;
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
                  _forgotPasswordForm(),
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
                    onPressed: () => _next(
                      data.phone,
                      data.dni,
                    ),
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

  Widget _forgotPasswordForm() {
    return DniPhoneForm(
      formKey: _formKey,
      data: data,
      onChange: (data) {
        this.data = data;
      },
    );
  }

  void _next(String phone, String dni) async {
    if (!_formKey.currentState.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());

    await _sendSmsCode(data.phone, data.dni);
    await _goToEnterSmsCode();
  }

  Future<void> _sendSmsCode(String phone, String dni) {
    return Auth.getAppToken().then((appToken) {
      return smsService
          .sendSMS(
            phone: phone,
            dni: dni,
            appToken: appToken,
          )
          .catchError(_onError);
    });
  }

  Future<void> _goToEnterSmsCode() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => SmsCode(
          phone: data.phone,
          dni: data.dni,
          onCode: _validateSmsCode,
        ),
      ),
    );
  }

  void _validateSmsCode(String smsCode) {
    EasyLoading.show();
    validateSMS.validateSMSCode(code: smsCode, NIF: data.dni).then(
      (value) {
        Navigator.of(context).popUntil(ModalRoute.withName(Routes.login));
        RecToast.showInfo(context, 'REGISTERED_OK');
        EasyLoading.dismiss();
      },
    ).catchError(_onError);
  }

  void _onError(error) {
    var localizations = AppLocalizations.of(context);
    EasyLoading.dismiss();
    RecToast.showError(
      context,
      localizations.translate(error['body']['message']),
    );
  }
}
