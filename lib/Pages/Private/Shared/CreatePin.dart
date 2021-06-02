import 'package:flutter/material.dart';
import 'package:rec/Api/Services/SecurityService.dart';
import 'package:rec/Api/Services/UserSmsService.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/RecPinInput.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Public/SmsCode/SmsCode.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';

class CreatePinWidget extends StatefulWidget {
  final Function(String pin) ifPin;
  final String label;
  final String buttonContent;
  final bool buttonWithArrow;

  const CreatePinWidget({
    Key key,
    @required this.ifPin,
    this.buttonContent,
    this.buttonWithArrow = true,
    this.label,
  }) : super(key: key);

  @override
  _CreatePinWidgetState createState() => _CreatePinWidgetState();
}

class _CreatePinWidgetState extends State<CreatePinWidget> {
  final _formKey = GlobalKey<FormState>();
  final _securityService = SecurityService();
  final _smsService = UserSmsService();

  String pin = '';

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    var localizations = AppLocalizations.of(context);
    var btnLabel = widget.buttonContent ?? localizations.translate('NEXT');
    var label =
        widget.label ?? localizations.translate('CREATE_AND') + ' ' + btnLabel;

    return Padding(
      padding: Paddings.page,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              localizations.translate('CREATE_PIN'),
              style: TextStyles.pageTitle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: Text(
              localizations.translate('CREATE_PIN_DESC'),
              style: TextStyles.pageSubtitle1,
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
                  icon: widget.buttonWithArrow
                      ? Icons.arrow_forward_ios_outlined
                      : null,
                  backgroundColor: Brand.primaryColor,
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
    if (!_formKey.currentState.validate()) return;

    // Send sms code
    await Loading.show();
    await _sendSmsCode()
        .then((value) => _goToEnterSmsCode())
        .catchError(_onError);
  }

  Future<void> _goToEnterSmsCode() async {
    var userState = UserState.of(context, listen: false);

    await Loading.dismiss();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => SmsCode(
          prefix: userState.user.prefix,
          phone: userState.user.phone,
          dni: userState.user.username,
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
    return widget.ifPin(pin);
  }

  Future _sendSmsCode() {
    return _smsService.sendChangePinSms();
  }

  void _onError(error) {
    var localizations = AppLocalizations.of(context);
    Loading.dismiss();
    RecToast.showError(
      context,
      localizations.translate(error.message),
    );
  }
}
