import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';

class PayOkScreen extends StatelessWidget {
  const PayOkScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(context),
      body: Center(
        child: Text('Payment OK'),
      ),
    );
  }
}
