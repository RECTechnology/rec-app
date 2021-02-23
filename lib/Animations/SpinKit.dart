import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinKit extends StatefulWidget{

  final double size;
  SpinKit({
    this.size
  });


  @override
  State<StatefulWidget> createState() => new _SpinKitState();
}

class _SpinKitState extends State<SpinKit> {
  final  spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(

        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Colors.black,
        width: widget.size,
        height: widget.size,
        child:spinkit ,
        alignment: Alignment.center,
      )
    );
  }
}
