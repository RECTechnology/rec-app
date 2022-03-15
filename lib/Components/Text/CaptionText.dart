import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';

class CaptionText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Alignment alignment;

  const CaptionText(
    this.text, {
    Key? key,
    this.style = const TextStyle(),
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  _CaptionText createState() => _CaptionText();
}

class _CaptionText extends State<CaptionText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.alignment,
      child: LocalizedText(
        widget.text,
        style: Theme.of(context).textTheme.caption!.merge(widget.style),
      ),
    );
  }
}
