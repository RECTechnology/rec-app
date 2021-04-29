import 'package:flutter/material.dart';

class RecHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Image(
        image: AssetImage('assets/login-header.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }
}
