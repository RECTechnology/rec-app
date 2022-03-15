import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/providers/AppLocalizations.dart';

class SimpleTextField extends StatefulWidget {
  final String? initialValue;
  final Color color;
  final String? label;
  final bool readOnly;

  final ValueChanged<String>? onChange;
  final FormFieldValidator<String>? validator;

  const SimpleTextField({
    Key? key,
    this.initialValue,
    this.onChange,
    this.validator,
    this.label,
    this.color = Colors.black87,
    this.readOnly = false,
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
      label: localizations!.translate(widget.label!),
      initialValue: widget.initialValue,
      keyboardType: TextInputType.text,
      needObscureText: false,
      placeholder: localizations.translate(widget.label!),
      onChange: widget.onChange,
      colorLine: widget.color,
      validator: widget.validator,
      readOnly: widget.readOnly,
      maxLines: 1,
      minLines: 1,
      icon: Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }
}
