import 'package:flutter/material.dart';
import 'package:rec/config/brand.dart';

class Borders {
  static Border borderTop = Border(
    top: BorderSide(
      color: Brand.separatorColor,
      width: 1,
      style: BorderStyle.solid,
    ),
  );
  static Border borderBottom = Border(
    bottom: BorderSide(
      color: Brand.separatorColor,
      width: 1,
      style: BorderStyle.solid,
    ),
  );
}
