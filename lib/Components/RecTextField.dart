import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../brand.dart';

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
  final String initialValue;
  final double textSize;
  final TextAlign textAlign;
  final double letterSpicing;
  
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
      this.isPhone,
       this.initialValue,
      this.textSize = 16,
      this.textAlign = TextAlign.left,
      this.letterSpicing = 0.0});

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
            initialValue: widget.initialValue,
            textAlign: widget.textAlign,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.colorLine),
              ),
              fillColor: Colors.lightBlueAccent,
              suffixIcon: isNotIcon
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          changeObscureText();
                        });
                      },
                      icon: Icon(obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,color: Brand.defectText,),
                    )
                  : widget.icon,
              errorText: hasError ? error : null,
              hintText: widget.placeholder,
            ),
            style: TextStyle(
                color: Colors.black,
                fontSize: widget.textSize,
                letterSpacing: widget.letterSpicing),
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
    print(string);
    if (widget.needObscureText == true ) {
      setState(() {
        obscureText = true;
        isNotIcon = true;
      });
    }
    widget.function(string);
  }

  void changeObscureText() {
    obscureText = !obscureText;
  }
}
