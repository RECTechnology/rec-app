import 'package:flutter/material.dart';
import 'package:rec/Providers/AppLocalizations.dart';

class LocalizedText extends StatefulWidget {
  final String text;
  final Map<String, dynamic> params;
  final TextStyle style;
  final TextAlign textAlign;
  final TextOverflow overflow;

  LocalizedText(
    this.text, {
    this.params,
    this.style,
    this.textAlign,
    Key key,
    this.overflow,
  }) : super(key: key);

  @override
  _LocalizedTextState createState() => _LocalizedTextState();
}

class _LocalizedTextState extends State<LocalizedText> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return Text(
      localizations.translate(widget.text, params: widget.params),
      style: widget.style,
      textAlign: widget.textAlign,
      overflow: widget.overflow,
    );
  }
}
