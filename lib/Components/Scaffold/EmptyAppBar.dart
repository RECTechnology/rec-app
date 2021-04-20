import 'package:flutter/material.dart';

Widget EmptyAppBar(BuildContext context, {bool backArrow = true}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: backArrow
        ? IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        : null,
  );
}
