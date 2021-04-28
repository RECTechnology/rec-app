import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';

class EnterPin extends StatefulWidget {
  final Function(String pin) ifPin;
  final String buttonContent;
  final bool buttonWithArrow;

  const EnterPin({
    Key key,
    @required this.ifPin,
    this.buttonContent,
    this.buttonWithArrow = true,
  }) : super(key: key);

  @override
  _EnterPinState createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  final _formKey = GlobalKey<FormState>();

  String pin;

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    var localizations = AppLocalizations.of(context);
    var btnLabel = widget.buttonContent ?? localizations.translate('NEXT');

    return Padding(
      padding: Paddings.page,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              localizations.translate('ENTER_PIN'),
              style: TextStyles.pageTitle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: Text(
              localizations.translate('ENTER_PIN_DESC'),
              style: TextStyles.pageSubtitle1,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32),
          Form(
            key: _formKey,
            child: Column(
              children: [
                RecTextField(
                  placeholder: '....',
                  needObscureText: true,
                  keyboardType: TextInputType.phone,
                  isNumeric: true,
                  textSize: 20,
                  letterSpicing: 25,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  colorLine: Brand.primaryColor,
                  onChange: setPin,
                  validator: Validators.smsCode,
                ),
                Text(
                  localizations.translate('FORGOT_PIN'),
                  style: TextStyles.link,
                ),
                RecActionButton(
                  label: btnLabel,
                  icon: widget.buttonWithArrow
                      ? Icons.arrow_forward_ios_outlined
                      : null,
                  backgroundColor: Brand.primaryColor,
                  onPressed: _next,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void setPin(String pin) {
    this.pin = pin;
  }

  void _next() {
    if (!_formKey.currentState.validate()) return;
    widget.ifPin(pin);
  }
}
