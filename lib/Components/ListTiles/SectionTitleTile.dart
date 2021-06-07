import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/brand.dart';

class SectionTitleTile extends StatelessWidget {
  final String title;

  const SectionTitleTile(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      title: LocalizedText(
        title,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(color: Brand.primaryColor),
      ),
    );
  }
}
