import 'package:flutter/material.dart';
import 'package:rec/config/assets.dart';

/// This widgets renders the REC Login header image
class RecHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Image(
        image: AssetImage(Assets.loginHeader),
        fit: BoxFit.cover,
      ),
    );
  }
}
