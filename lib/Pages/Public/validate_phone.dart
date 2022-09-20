import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rec/Components/Forms/DniPhone.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Layout/FormPageLayout.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Public/SmsCode/SmsCode.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ValidatePhone extends StatefulWidget {
  final String? dni;
  final PhoneVerificationService verificationService;
  final PublicSMSService smsService;

  ValidatePhone({
    this.dni = '',
    PhoneVerificationService? verificationService,
    PublicSMSService? smsService,
  })  : verificationService = verificationService ?? PhoneVerificationService(env: env),
        smsService = smsService ?? PublicSMSService(env: env);

  @override
  _ValidatePhoneState createState() => _ValidatePhoneState();
}

class _ValidatePhoneState extends State<ValidatePhone> {
  final _formKey = GlobalKey<FormState>();
  DniPhoneData? data;

  @override
  void initState() {
    super.initState();
    data = DniPhoneData(dni: widget.dni);
  }

  bool get isFormValid {
    return data!.valid();
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
   
    return FormPageLayout(
      appBar: EmptyAppBar(context),
      form: _phoneForm(),
      header: _topTexts(),
      submitButton: RecActionButton(
        label: 'NEXT',
        backgroundColor: recTheme!.primaryColor,
        icon: Icons.arrow_forward_ios_sharp,
        onPressed: isFormValid ? _next : null,
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

  Widget _phoneForm() {
    return DniPhoneForm(
      formKey: _formKey,
      data: data,
      onChange: (data) {
        setState(() => this.data = data);
      },
    );
  }

  void _next() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());

    await Loading.show();
    await _sendSmsCode().then((value) => _goToEnterSmsCode()).catchError(_onError);
  }

  Future<void> _sendSmsCode() {
    return widget.smsService.sendValidatePhoneSms(
      phone: data!.phone,
      prefix: data!.prefix,
    );
  }

  Future<void> _goToEnterSmsCode() async {
    await Loading.dismiss();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => SmsCode(
          prefix: data!.prefix,
          phone: data!.phone,
          dni: data!.dni,
          onCode: _validateSmsCode,
        ),
      ),
    );
  }

  void _validateSmsCode(String smsCode) {
    EasyLoading.show();
    widget.verificationService
        .validatePhone(
          smscode: smsCode,
          dni: data!.dni,
          prefix: data!.prefix,
          phone: data!.phone,
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
    EasyLoading.dismiss();
    if (error.message == 'Incorrect Code') {
      RecToast.showError(context, 'WRONG_SMS');
      return;
    } else {
      RecToast.showError(context, error.message);
    }
  }
}
