import 'package:flutter/material.dart';
import 'package:rec/Components/RecTextField.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class DniTextField extends StatefulWidget {
  final String initialValue;
  final Function(String newValue) onChange;
  final Function(String value) validator;
  final Color color;

  const DniTextField({
    Key key,
    this.initialValue,
    this.onChange,
    this.validator,
    this.color = Colors.black87,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DniTextFieldState();
  }
}

class DniTextFieldState extends State<DniTextField> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return RecTextField(
      label: localizations.translate('DNI_NIE'),
      initialValue: widget.initialValue,
      isNumeric: false,
      keyboardType: TextInputType.text,
      needObscureText: false,
      placeholder: localizations.translate('DNI_NIE'),
      onChange: widget.onChange,
      colorLine: widget.color,
      validator: widget.validator,
      isPhone: false,
      icon: Icon(
        Icons.person,
        color: Brand.grayIcon,
      ),
    );
  }
}
