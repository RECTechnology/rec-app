import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class RecTextField extends StatefulWidget {
  final String title;
  final String placeholder;
  final TextInputType keyboardType;
  final bool isNumeric;
  final bool needObscureText;
  final bool isPassword;
  final Color colorLine;
  final Function(String string) function;
  final Icon icon;
  final Function validator;
  final bool isPhone;

  RecTextField(
      {this.title,
      this.keyboardType = TextInputType.text,
      this.isNumeric = false,
      this.needObscureText = false,
      this.placeholder,
      this.isPassword,
      this.colorLine = Colors.black87,
      this.function,
      this.icon,
      this.validator,
      this.isPhone});

  @override
  _InputField createState() => _InputField();
}

class _InputField extends State<RecTextField> {
  bool obscureText = false;
  bool hasError = false;
  String error = 'Contraseña incorrecta';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              )
            ],
          ),
        ),
        Container(
          child: TextFormField(
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.colorLine),
              ),
              fillColor: Colors.lightBlueAccent,
              suffixIcon: obscureText
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          changeObscureText();
                        });
                      },
                      icon: Icon(obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    )
                  : widget.icon,
              errorText: hasError ? error : null,
              hintText: widget.placeholder,
            ),
            style: TextStyle(color: Colors.black),
            onChanged: onChanged,
            obscureText: obscureText ? true : false,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
          ),
        ),
      ],
    );
  }

  void onChanged(String string) {
    if (widget.needObscureText == true) {
      setState(() {
        obscureText = true;
      });
    }
    widget.function(string);
  }

  void changeObscureText() {
    obscureText = !obscureText;
  }
}
