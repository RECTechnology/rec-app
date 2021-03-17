import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecTextField extends StatefulWidget {
  final String title;
  final String placeholder;
  final TextInputType keyboardType;
  final bool isNumeric;
  final String helperText;
  final bool needObscureText;
  final bool isPassword;
  final Function(String string) onChanged;

  RecTextField(
      {this.title,
      this.keyboardType = TextInputType.text,
      this.isNumeric = false,
      this.needObscureText = false,
      this.helperText,
      this.placeholder,
      this.isPassword,
      this.onChanged,
      });

  @override
  _InputField createState() => _InputField();
}

class _InputField extends State<RecTextField> {
  bool obscureText = true;
  bool hasError = false;
  String error = "Contraseña incorrecta";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10), //Left,Top,Right,Bottom
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
          child: TextFormField(
            decoration: InputDecoration(
              errorBorder: UnderlineInputBorder(
                borderSide: hasError
                    ? BorderSide(color: Colors.red)
                    : BorderSide(color: Colors.black),
              ),
              suffixIcon: widget.needObscureText
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
                  : null,
              errorText: this.hasError ? this.error : null,
              hintText: widget.placeholder,
              helperText: widget.helperText,
            ),
            onChanged: widget.onChanged,
            style: TextStyle(color: Colors.black),
            obscureText: obscureText ? true : false,
            keyboardType: widget.keyboardType,
          ),
        ),
      ],
    );
  }

  void tastePassword(String password) {
    if (password == "qwerty") {
      setState(() {
        print("Es correcta la contraseña");
        hasError = false;
      });
    } else {
      setState(() {
        hasError = true;
      });
    }

    print(password);
  }

  void changeObscureText() {
    this.obscureText = !this.obscureText;
    print("obscureText = " + obscureText.toString());
  }

  void onChanged(String val) {}
}
