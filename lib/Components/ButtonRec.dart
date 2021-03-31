import 'package:flutter/material.dart';

class ButtonRec extends StatefulWidget {
  final String text;
  final Widget widget;
  final Function() onPressed;
  final Color textColor;
  final Color backgroundColor;
  final double widthBox;
  final bool isButtonDisabled;

  ButtonRec({
    this.text,
    this.widget,
    this.onPressed,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.widthBox,
    this.isButtonDisabled
  });

  @override
  State<StatefulWidget> createState() {
    return ButtonRecState();
  }
}

class ButtonRecState extends State<ButtonRec> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    }

  @override
  Widget build(BuildContext context) {
    var areWidget = true;
    if (widget.widget == null) {
      areWidget = false;
    }


    var button = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: widget.isButtonDisabled?null:widget.onPressed,
      textColor: widget.textColor,
      color: widget.backgroundColor,

      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              alignment: Alignment.centerRight,
              child: Text(widget.text,style: TextStyle(fontSize: 20),),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              alignment: Alignment.centerRight,
              child: areWidget ? widget.widget : null,
            ),
          ],
        ),
      ),
    );

    return SizedBox(
      width: widget.widthBox,
      height: 50.0,
      child: button,
    );
  }
}
