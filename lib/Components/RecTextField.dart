import 'package:flutter/material.dart';
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

  RecTextField({
    this.title,
    this.keyboardType = TextInputType.text,
    this.isNumeric = false,
    this.needObscureText = false,
    this.placeholder,
    this.isPassword,
    this.colorLine,
    this.function,
    this.icon,
  });

  @override
  _InputField createState() => _InputField();
}

class _InputField extends State<RecTextField> {
  bool obscureText = false;
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
                  widget.title != null ? widget.title : "",
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
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.colorLine),
              ),
              fillColor: Colors.lightBlueAccent,
              errorBorder: OutlineInputBorder(
                borderSide: hasError
                    ? BorderSide(color: Colors.red)
                    : BorderSide(color: Colors.black),
              ),
              suffixIcon: obscureText?
                   IconButton(
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
              errorText: this.hasError ? this.error : null,
              hintText: widget.placeholder,
            ),
            style: TextStyle(color: Colors.black),
            onChanged: onChanged,
            obscureText: obscureText ? true : false,
            keyboardType: widget.keyboardType,
          ),
        ),
      ],
    );
  }

  void onChanged(String string){

    if(widget.needObscureText == true){
      setState(() {
        obscureText = true;
      });
    }
    widget.function;
  }

  void changeObscureText() {
    this.obscureText = !this.obscureText;
    print("obscureText = " + obscureText.toString());
  }

}
