import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class PasswordField extends StatefulWidget {
  final String initialValue;

  final ValueChanged<String> onChange;
  final ValueChanged<String> onSubmitted;
  final FormFieldValidator<String> validator;

  final Color color;
  final String title;
  final String placeholder;
  final bool autofocus;

  /// Defines the keyboard focus for this widget.
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  final FocusNode focusNode;

  const PasswordField({
    Key key,
    this.initialValue,
    this.onChange,
    this.validator,
    this.color = Colors.black87,
    this.title = 'PASSWORD',
    this.autofocus = false,
    this.onSubmitted,
    this.focusNode,
    this.placeholder,
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
      placeholder: widget.placeholder ?? localizations.translate(widget.title),
      initialValue: widget.initialValue,
      needObscureText: true,
      keyboardType: TextInputType.visiblePassword,
      icon: Icon(Icons.lock, color: Brand.grayIcon),
      colorLine: widget.color,
      onChange: widget.onChange,
      validator: widget.validator,
      onSubmitted: widget.onSubmitted,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      maxLines: 1,
      minLines: 1,
    );
  }
}
