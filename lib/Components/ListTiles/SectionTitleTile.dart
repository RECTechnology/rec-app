import 'package:flutter/material.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class SectionTitleTile extends StatelessWidget {
  final String title;

  const SectionTitleTile(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return ListTile(
      title: Text(
        localizations.translate(title),
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(color: Brand.primaryColor),
      ),
    );
  }
}
