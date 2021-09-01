import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/text_fields/RecPinInput.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

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

  bool get formValid => Checks.isNotEmpty(pin) && pin.length == 4;

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
              localizations.translate('PIN'),
              style: TextStyles.pageTitle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
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
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RecPinInput(
                    autofocus: true,
                    fieldsCount: 4,
                    onSaved: (s) => _next(),
                    onChanged: _setPin,
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: _forgotPin,
                  child: Text(
                    localizations.translate('FORGOT_PIN'),
                    style: TextStyles.link,
                  ),
                ),
                RecActionButton(
                  label: btnLabel,
                  icon: widget.buttonWithArrow ? Icons.arrow_forward_ios_outlined : null,
                  backgroundColor: Brand.primaryColor,
                  onPressed: formValid ? _next : null,
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

  void _next() {
    if (!_formKey.currentState.validate() || !formValid) return;
    widget.ifPin(pin);
  }

  void _forgotPin() {
    Navigator.pushNamed(context, Routes.settingsUserChangePin);
  }
}
