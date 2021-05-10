import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class PasswordField extends StatefulWidget {
  final String initialValue;
  final Function(String newValue) onChange;
  final Function(String newValue) onSubmitted;
  final Function(String value) validator;
  final Color color;
  final String title;
  final bool autofocus;

  const PasswordField({
    Key key,
    this.initialValue,
    this.onChange,
    this.validator,
    this.color = Colors.black87,
    this.title = 'PASSWORD',
    this.autofocus = false,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PasswordFieldState();
  }
}

class PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return RecTextField(
      label: localizations.translate(widget.title),
      placeholder: localizations.translate(widget.title),
      initialValue: widget.initialValue,
      needObscureText: true,
      autofocus: widget.autofocus,
      keyboardType: TextInputType.visiblePassword,
      icon: Icon(Icons.lock, color: Brand.grayIcon),
      colorLine: widget.color,
      onChange: widget.onChange,
      validator: widget.validator,
      onSubmitted: widget.onSubmitted,
    );
  }
}
