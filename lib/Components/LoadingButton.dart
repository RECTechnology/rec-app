import 'package:rec/Animations/SpinKit.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final String text;
  final Function() onPressed;
  final bool isLoading;

  LoadingButton({
    this.text = 'Empty',
    this.onPressed,
    this.isLoading,
  });

  @override
  State<StatefulWidget> createState() {
    return LoadingButtonState();
  }
}

class LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) {
    var buttonRec = ButtonRec(
      onPressed: widget.onPressed,
      text: Text('Login'),
    );

    var containerNotLoading = Container(
      child: Row(
        children: [
          ButtonRec(
            onPressed: widget.onPressed,
            text: Text('Login'),
          )
        ],
      ),
    );

    var containerLoading = Container(
      height: 50,
      width: 300,
      child: Row(
        children: [
          Container(
            height: 120,
            width: 120,
            child: SpinKit(
              size: 50,
            ),
          ),
          buttonRec
        ],
      ),
    );
    return widget.isLoading ? containerLoading : containerNotLoading;
  }
}
