import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../brand.dart';

class RecTextField extends StatefulWidget {
  final String placeholder;
  final TextInputType keyboardType;

  final bool isNumeric;
  final bool needObscureText;
  final bool isPassword;
  final bool isPhone;

  final String initialValue;
  final String label;

  final Color colorLine;
  final Color colorLabel;
  final Icon icon;
  final Function(String string) onChange;
  final Function validator;
  final TextAlign textAlign;
  final double textSize;
  final double letterSpicing;

  RecTextField({
    this.keyboardType = TextInputType.text,
    this.isNumeric = false,
    this.needObscureText = false,
    this.isPassword = false,
    this.colorLine = Colors.black87,
    this.colorLabel = Colors.black87,
    this.placeholder,
    this.onChange,
    this.icon,
    this.validator,
    this.isPhone,
    this.initialValue,
    this.textSize = 16,
    this.textAlign = TextAlign.left,
    this.letterSpicing = 0.0,
    this.label,
  });

  @override
  _InputField createState() => _InputField();
}

class _InputField extends State<RecTextField> {
  bool obscureText = false;
  bool hasError = false;
  String error = 'Contraseña incorrecta';
  bool isNotIcon = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      textAlign: widget.textAlign,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.colorLine),
        ),
        fillColor: Colors.lightBlueAccent,
        suffixIcon: isNotIcon
            ? IconButton(
                onPressed: () => setState(() => changeObscureText()),
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Brand.grayIcon,
                ),
              )
            : widget.icon,
        errorText: hasError ? error : null,
        hintText: widget.placeholder,
        labelText: widget.label,
        labelStyle: TextStyle(color: widget.colorLabel),
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: widget.textSize,
        letterSpacing: widget.letterSpicing,
      ),
      onChanged: onChanged,
      obscureText: obscureText ? true : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
    );
  }

  void onChanged(String string) {
    print(string);
    if (widget.needObscureText == true) {
      setState(() {
        obscureText = true;
        isNotIcon = true;
      });
    }
    widget.onChange(string);
  }

  void changeObscureText() {
    obscureText = !obscureText;
  }
}
