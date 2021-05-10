import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class AmountTextField extends StatefulWidget {
  final String initialValue;
  final Function(String newValue) onChange;
  final Function(String newValue) onSubmitted;
  final Function(String value) validator;
  final Color color;
  final bool readOnly;
  final bool autofocus;

  const AmountTextField({
    Key key,
    this.initialValue,
    this.onChange,
    this.validator,
    this.color = Colors.black87,
    this.readOnly = false,
    this.autofocus = false,
    this.onSubmitted,
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
      initialValue: widget.initialValue ?? '',
      isNumeric: false,
      keyboardType: TextInputType.number,
      needObscureText: false,
      placeholder: localizations.translate('WRITE_AMOUNT'),
      onChange: widget.onChange,
      onSubmitted: widget.onSubmitted,
      colorLine: widget.color,
      validator: widget.validator,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      isPhone: false,
      icon: Icon(
        Icons.euro,
        color: Brand.grayIcon,
      ),
    );
  }
}
