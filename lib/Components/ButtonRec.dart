import 'package:flutter/material.dart';



class ButtonRec extends StatefulWidget {
  final Text text;
  final Widget widget;
  final Function() onPressed;
  final Color textColor;
  final Color backgroundColor;
  ButtonRec({
    this.text ,
    this.widget,
    this.onPressed,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black
  });

  @override
  State<StatefulWidget> createState() {
    return ButtonRecState();
  }
}

class ButtonRecState extends State<ButtonRec> {


  @override
  Widget build(BuildContext context) {
    var areWidget = true;

    if(widget.widget == null){
      areWidget = false;
    }

    RaisedButton button = RaisedButton(

      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(
              height: 25,
            ),

            widget.text

          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: widget.onPressed,
      textColor: widget.textColor,
      color: widget.backgroundColor,
    );RaisedButton buttonWhitWidget = RaisedButton(

      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(
              height: 25,
            ),

            widget.text

          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: widget.onPressed,
      textColor: widget.textColor,
      color: widget.backgroundColor,
    );


    return button;
  }
}