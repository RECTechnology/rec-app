import 'package:flutter/material.dart';

class RechargeResult extends StatefulWidget {
  @override
  _RechargeResultState createState() => _RechargeResultState();
}

class _RechargeResultState extends State<RechargeResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.fromLTRB(32, 84, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('result')],
      ),
    );
  }
}
