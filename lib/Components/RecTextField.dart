import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecTextField extends StatefulWidget {
  final String title;
  final String placeholder;
  final TextInputType keyboardType;
  final bool isNumeric;
  final bool needObscureText;
  final bool isPassword;
  final Function(String string) function;
  RecTextField({
    this.title,
    this.keyboardType = TextInputType.text,
    this.isNumeric = false,
    this.needObscureText = false,
    this.placeholder,
    this.isPassword,
    this.function,
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
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0), //Left,Top,Right,Bottom
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
          margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
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
              errorText: hasError ? error : null,
              hintText: widget.placeholder,
            ),
            style: TextStyle(color: Colors.black),
            onChanged: widget.function,
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
