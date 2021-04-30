import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Providers/AppLocalizations.dart';

class SimpleTextField extends StatefulWidget {
  final String initialValue;
  final Function(String newValue) onChange;
  final Function(String value) validator;
  final Color color;
  final String label;

  const SimpleTextField({
    Key key,
    this.initialValue,
    this.onChange,
    this.validator,
    this.color = Colors.black87,
    this.label,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SimpleTextFieldState();
  }
}

class SimpleTextFieldState extends State<SimpleTextField> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return RecTextField(
      label: localizations.translate(widget.label),
      initialValue: widget.initialValue,
      isNumeric: false,
      keyboardType: TextInputType.text,
      needObscureText: false,
      placeholder: localizations.translate(widget.label),
      onChange: widget.onChange,
      colorLine: widget.color,
      validator: widget.validator,
      isPhone: false,
      icon: Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }
}
