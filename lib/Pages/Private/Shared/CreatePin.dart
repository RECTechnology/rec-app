import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/text_fields/RecPinInput.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Public/SmsCode/SmsCode.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CreatePinWidget extends StatefulWidget {
  final Function(String pin) ifPin;
  final String? label;
  final String? buttonContent;
  final bool buttonWithArrow;

  const CreatePinWidget({
    Key? key,
    required this.ifPin,
    this.buttonContent,
    this.buttonWithArrow = true,
    this.label,
  }) : super(key: key);

  @override
  _CreatePinWidgetState createState() => _CreatePinWidgetState();
}

class _CreatePinWidgetState extends State<CreatePinWidget> {
  final _formKey = GlobalKey<FormState>();
  final _securityService = SecurityService(env: env);
  final _smsService = UserSmsService(env: env);

  String pin = '';

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    final recTheme = RecTheme.of(context);
    final localizations = AppLocalizations.of(context);
    final btnLabel = widget.buttonContent ?? localizations!.translate('NEXT');
    final label = widget.label ?? localizations!.translate('CREATE_AND') + ' ' + btnLabel;

    return Padding(
      padding: Paddings.page,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: LocalizedText(
              'CREATE_PIN',
              style: recTheme!.textTheme.pageTitle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: LocalizedText(
              'CREATE_PIN_DESC',
              style: recTheme.textTheme.pageSubtitle1,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RecPinInput(
                    autofocus: true,
                    fieldsCount: 4,
                    onSaved: (s) => _next(),
                    onChanged: _setPin,
                  ),
                ),
                RecActionButton(
                  label: label,
                  icon: widget.buttonWithArrow ? Icons.arrow_forward_ios_outlined : null,
                  backgroundColor: recTheme.primaryColor,
                  onPressed: pin.length == 4 ? _next : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _setPin(String pin) {
    setState(() => this.pin = pin);
  }

  void _next() async {
    if (!_formKey.currentState!.validate()) return;

    // Send sms code
    await Loading.show();
    await _sendSmsCode().then((value) => _goToEnterSmsCode()).catchError(_onError);
  }

  Future<void> _goToEnterSmsCode() async {
    var userState = UserState.of(context, listen: false);

    await Loading.dismiss();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => SmsCode(
          prefix: userState.user!.prefix,
          phone: userState.user!.phone,
          dni: userState.user!.username,
          onCode: (code) {
            Navigator.of(context).pop();
            _createPinWidget(code);
          },
        ),
      ),
    );
  }

  Future _createPinWidget(String smsCode) {
    Loading.show();
    return _securityService
        .createPin(pin: pin, repin: pin, smscode: smsCode)
        .then((r) => _pinCreated(pin))
        .catchError(_onError);
  }

  void _pinCreated(String pin) {
    Loading.dismiss();
    widget.ifPin(pin);
  }

  Future _sendSmsCode() {
    return _smsService.sendChangePinSms();
  }

  void _onError(error) {
    Loading.dismiss();
    RecToast.showError(context, error.message);
  }
}
