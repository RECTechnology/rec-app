import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/brand.dart';

class SectionTitleTile extends StatelessWidget {
  final Color textColor;
  final FontWeight fontWeight;
  final String title;

  const SectionTitleTile(
    this.title, {
    Key key,
    this.textColor = Brand.primaryColor,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  const SectionTitleTile.gray(
    this.title, {
    Key key,
    this.fontWeight = FontWeight.normal,
  }) : textColor = Brand.grayDark;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return ListTile(
      tileColor: Colors.white,
      title: LocalizedText(
        title,
        style: textTheme.subtitle1.copyWith(
          color: textColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
