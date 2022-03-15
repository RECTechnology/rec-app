import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/brand.dart';

class LinkText extends StatefulWidget {
  final String text;
  final Color color;
  final Alignment alignment;
  final Function? onTap;
  final EdgeInsets padding;

  const LinkText(
    this.text, {
    Key? key,
    this.color = Brand.primaryColor,
    this.alignment = Alignment.centerLeft,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  }) : super(key: key);

  @override
  _LinkText createState() => _LinkText();
}

class _LinkText extends State<LinkText> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap as void Function()?,
      child: Container(
        alignment: widget.alignment,
        padding: widget.padding,
        child: LocalizedText(
          widget.text,
          style: Theme.of(context).textTheme.caption!.copyWith(
                color: widget.color,
                decoration: TextDecoration.underline,
              ),
        ),
      ),
    );
  }
}
