import 'package:flutter/material.dart';

class FromToRow extends StatefulWidget {
  final Widget from;
  final Widget to;

  const FromToRow({
    Key key,
    @required this.from,
    @required this.to,
  }) : super(key: key);

  @override
  _FromToRow createState() => _FromToRow();
}

class _FromToRow extends State<FromToRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          child: widget.from,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Icon(Icons.arrow_right_alt),
        ),
        Container(
          width: 60,
          height: 60,
          child: widget.to,
        ),
      ],
    );
  }
}
