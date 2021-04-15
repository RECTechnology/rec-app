import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PayTab extends StatefulWidget {
  PayTab({Key key}) : super(key: key);

  @override
  _PayTabState createState() => _PayTabState();
}

class _PayTabState extends State<PayTab> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Pay'));
  }
}
