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
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Public/SetPassword/SetPassword.dart';
import 'package:rec/Pages/Public/SmsCode/SmsCode.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ForgotPassword extends StatefulWidget {
  final String dni;
  final PublicSMSService smsService;

  ForgotPassword({
    this.dni = '',
    PublicSMSService? smsService,
  }) : smsService = smsService ?? PublicSMSService(env: env);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  DniPhoneData? data;

  @override
  void initState() {
    super.initState();
    data = DniPhoneData(dni: widget.dni);
  }

  @override
  Widget build(BuildContext context) {
    final validData = data!.valid();
    final recTheme = RecTheme.of(context);

    return FormPageLayout(
      appBar: EmptyAppBar(context),
      header: _topTexts(),
      form: _forgotPasswordForm(),
      submitButton: RecActionButton(
        label: 'NEXT',
        backgroundColor: recTheme!.primaryColor,
        icon: Icons.arrow_forward_ios_sharp,
        onPressed: validData ? _next : null,
      ),
    );
  }

  Widget _topTexts() {
    return Column(
      children: [
        TitleText('FORGOT_PASSWORD'),
        SizedBox(height: 16),
        CaptionText('ITRODUCE_DNI_TELF'),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _forgotPasswordForm() {
    return DniPhoneForm(
      formKey: _formKey,
      data: data,
      onChange: (data) {
        setState(() {
          this.data = data;
        });
      },
    );
  }

  void _next() async {
    if (!_formKey.currentState!.validate()) return;

    await EasyLoading.show();
    await widget.smsService
        .sendForgotPasswordSms(
          phone: data!.phone,
          prefix: data!.prefix,
          dni: data!.dni,
        )
        .then((c) => _goToSmsCode())
        .catchError(_smsError);
  }

  void _smsError(err) {
    EasyLoading.dismiss();

    if (err.message == 'Smscode not found') {
      RecToast.showError(context, 'WRONG_SMS');
      return;
    }

    RecToast.showError(context, err.message);
  }

  void _goToSmsCode() async {
    await EasyLoading.dismiss();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => SmsCode(
          prefix: data!.prefix,
          phone: data!.phone,
          dni: data!.dni,
          onCode: (c) => _gotCode(c),
        ),
      ),
    );
  }

  void _gotCode(String code) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (c) => SetPasswordPage(data, code)),
    );
  }
}
