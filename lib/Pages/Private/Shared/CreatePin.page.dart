import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/RecPinInput.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';

class CreatePin extends StatefulWidget {
  final Function(String pin) ifPin;
  final String buttonContent;
  final bool buttonWithArrow;

  const CreatePin({
    Key key,
    @required this.ifPin,
    this.buttonContent,
    this.buttonWithArrow = true,
  }) : super(key: key);

  @override
  _CreatePinState createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> {
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
                  label: localizations.translate('CREATE_AND') + ' ' + btnLabel,
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

  void _setPin(String pin) {
    this.pin = pin;
  }

  void _next() {
    if (!_formKey.currentState.validate()) return;

    // TODO: Call api and set pin (waiting api)
    Navigator.of(context).pop(pin);
  }
}
