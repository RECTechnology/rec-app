import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';

/// This widgets renders the REC Login header image
class RecHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final assets = RecTheme.of(context)!.assets;

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Image(
        image: AssetImage(assets.loginHeader),
        fit: BoxFit.cover,
      ),
    );
  }
}
