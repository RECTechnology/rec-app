import 'package:flutter/material.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class LinkText extends StatefulWidget {
  final String text;
  final Color color;
  final Alignment alignment;
  final Function onTap;

  const LinkText(
    this.text, {
    Key key,
    this.color = Brand.primaryColor,
    this.alignment = Alignment.centerLeft,
    this.onTap,
  }) : super(key: key);

  @override
  _LinkText createState() => _LinkText();
}

class _LinkText extends State<LinkText> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        alignment: widget.alignment,
        child: Text(
          localizations.translate(widget.text),
          style: Theme.of(context).textTheme.caption.copyWith(
                color: widget.color,
                decoration: TextDecoration.underline,
              ),
        ),
      ),
    );
  }
}
