import 'package:flutter/material.dart';
import 'package:rec/Providers/AppLocalizations.dart';

class CaptionText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const CaptionText(
    this.text, {
    Key key,
    this.style = const TextStyle(),
  }) : super(key: key);

  @override
  _CaptionText createState() => _CaptionText();
}

class _CaptionText extends State<CaptionText> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        localizations.translate(widget.text),
        style: Theme.of(context).textTheme.caption.merge(widget.style),
      ),
    );
  }
}
