import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/ChangePinForm.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Public/SmsCode/SmsCode.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ChangePinPage extends StatefulWidget {
  @override
  _ChangePinPageState createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final _securityService = SecurityService(env: env);
  final _smsService = UserSmsService(env: env);
  final _formKey = GlobalKey<FormState>();

  bool touched = false;

  ChangePinData data = ChangePinData();

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
  
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: EmptyAppBar(
          context,
          title: 'CHANGE_PIN',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Paddings.page,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChangePinForm(
                  formKey: _formKey,
                  onChangePin: onChangePin,
                  onChangeRePin: onChangeRePin,
                  onChangePassword: onChangePassword,
                ),
                if (touched && data.pin != data.repin)
                  LocalizedText(
                    'PINS_DO_NOT_MATCH',
                    style: Theme.of(context).textTheme.caption!.copyWith(color: recTheme!.red),
                  ),
                RecActionButton(
                  label: 'UPDATE',
                  backgroundColor: recTheme!.primaryColor,
                  onPressed: data.isValid ? () => update() : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onChangePin(String string) {
    if (string.isNotEmpty) {
      touched = true;
    }
    setState(() => data.pin = string);
  }

  void onChangeRePin(String string) {
    if (string.isNotEmpty) {
      touched = true;
    }
    setState(() => data.repin = string);
  }

  void onChangePassword(String string) {
    if (string.isNotEmpty) {
      touched = true;
    }
    setState(() => data.password = string);
  }

  void update() {
    if (!_formKey.currentState!.validate()) return;

    Loading.show();
    _sendSmsCode().then(_goToEnterSmsCode).catchError(_onError);
  }

  Future _sendSmsCode() {
    return _smsService.sendChangePinSms();
  }

  Future<void> _goToEnterSmsCode(d) async {
    var userState = UserState.of(context, listen: false);

    await Loading.dismiss();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => SmsCode(
          prefix: userState.user!.prefix,
          phone: userState.user!.phone,
          dni: userState.user!.username,
          onCode: (code) {
            Navigator.pop(context);

            setState(() => data.smsCode = code);

            _tryChangePin();
          },
        ),
      ),
    );
  }

  Future _tryChangePin() {
    Loading.show();
    return _securityService.changePin(data).then(_changePinOK).catchError(_onError);
  }

  void _changePinOK(result) {
    var userState = UserState.of(context, listen: false);
    userState.setUser(userState.user!..hasPin = true);

    Loading.dismiss();
    RecToast.showSuccess(context, 'CHANGE_PIN_OK');
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  void _onError(error) {
    Loading.dismiss();
    RecToast.showError(context, error.message);
  }
}
