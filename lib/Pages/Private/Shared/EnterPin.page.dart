import 'package:flutter/material.dart';
import 'package:rec/Components/RecActionButton.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Helpers/VerifyDataRec.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';

class EnterPin extends StatefulWidget {
  const EnterPin({
    Key key,
  }) : super(key: key);

  @override
  _EnterPinState createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  final _formKey = GlobalKey<FormState>();

  String pin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(context),
      body: _body(),
    );
  }

  Widget _body() {
    var localizations = AppLocalizations.of(context);

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
                  autofocus: true,
                  textSize: 20,
                  letterSpicing: 25,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  colorLine: Brand.primaryColor,
                  onChange: setPin,
                  validator: VerifyDataRec.smsCode,
                ),
                Text(
                  localizations.translate('FORGOT_PIN'),
                  style: TextStyles.link,
                ),
                RecActionButton(
                  label: localizations.translate('NEXT'),
                  icon: Icons.arrow_forward_ios_outlined,
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
    Navigator.of(context).pop(pin);
  }
}
