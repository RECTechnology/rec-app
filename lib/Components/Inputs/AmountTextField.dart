import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class AmountTextField extends StatefulWidget {
  final String initialValue;
  final Function(String newValue) onChange;
  final Function(String value) validator;
  final Color color;

  const AmountTextField({
    Key key,
    this.initialValue,
    this.onChange,
    this.validator,
    this.color = Colors.black87,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AmountTextFieldState();
  }
}

class AmountTextFieldState extends State<AmountTextField> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return RecTextField(
      label: localizations.translate('AMOUNT'),
      initialValue: widget.initialValue,
      isNumeric: false,
      keyboardType: TextInputType.number,
      needObscureText: false,
      placeholder: localizations.translate('WRITE_AMOUNT'),
      onChange: widget.onChange,
      colorLine: widget.color,
      validator: widget.validator,
      isPhone: false,
      icon: Icon(
        Icons.euro,
        color: Brand.grayIcon,
      ),
    );
  }
}
