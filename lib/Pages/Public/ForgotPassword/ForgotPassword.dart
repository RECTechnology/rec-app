import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/SMSService.dart';
import 'package:rec/Components/Forms/DniPhone.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Public/SetPassword/SetPassword.dart';
import 'package:rec/Pages/Public/SmsCode/SmsCode.dart';

import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class ForgotPassword extends StatefulWidget {
  final String dni;

  ForgotPassword({this.dni = ''});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final smsService = SMSService();
  final _formKey = GlobalKey<FormState>();

  DniPhoneData data = DniPhoneData();

  @override
  void initState() {
    super.initState();
    data.dni = widget.dni;
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Paddings.pageNoTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topTexts(),
                _forgotPasswordForm(),
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
        this.data = data;
      },
    );
  }

  void _next(String phone, String dni) async {
    if (!_formKey.currentState.validate()) return;

    await EasyLoading.show();
    await Auth.getAppToken().then((appToken) {
      return smsService
          .sendSMS(
            phone: phone,
            dni: dni,
            appToken: appToken,
          )
          .then((c) => _goToSmsCode(phone, dni))
          .catchError(_smsError);
    });
  }

  void _smsError(err) {
    print(err);
    EasyLoading.dismiss();
    RecToast.showError(context, err['body']['message']);
  }

  void _goToSmsCode(String phone, String dni) async {
    await EasyLoading.dismiss();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => SmsCode(
          phone: phone,
          dni: dni,
          onCode: (c) => _gotCode(c),
        ),
      ),
    );
  }

  void _gotCode(String code) {
    print('got code $code');
    Navigator.of(context).push(
      MaterialPageRoute(builder: (c) => SetPasswordPage(code)),
    );
  }
}