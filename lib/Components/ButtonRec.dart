import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rec/Animations/SpinKit.dart';


class ButtonRec extends StatefulWidget {
  final String text;
  final Function() onPressed;

  ButtonRec({
    this.text = 'Empty',
    this.onPressed,
  });

  @override
  State<StatefulWidget> createState() {
    return ButtonRecState();
  }
}

class ButtonRecState extends State<ButtonRec> {




  @override
  Widget build(BuildContext context) {

    RaisedButton button = RaisedButton(

      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Container(
              height: 40,
              width: 40,
              child: SpinKit(size: 50,),
              color: Colors.black,

            )  ,
            new Text(
                widget.text,
                textDirection:  TextDirection.ltr,)

          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: widget.onPressed,
      textColor: Colors.white,
      color: Colors.black,
    );



    return button;
  }
}
