import 'package:flutter/material.dart';
import 'package:rec/Components/Info/InfoTooltip.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class TitleText extends StatefulWidget {
  final String title;
  final TextStyle style;
  final MainAxisAlignment alignment;

  final String tooltipText;
  final bool showTooltip;
  final Color tooltipColor;
  final IconData tooltipIcon;

  const TitleText(
    this.title, {
    Key key,
    this.style = const TextStyle(),
    this.showTooltip = false,
    this.tooltipText = '',
    this.tooltipColor = Brand.grayDark2,
    this.tooltipIcon = Icons.help_outline,
    this.alignment = MainAxisAlignment.start,
  }) : super(key: key);

  @override
  _TitleText createState() => _TitleText();
}

class _TitleText extends State<TitleText> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: widget.alignment,
      children: [
        Text(
          localizations.translate(widget.title),
          style: Theme.of(context).textTheme.headline6.merge(widget.style),
        ),
        InfoTooltip.accent(
          message: localizations.translate(widget.tooltipText),
          child: Container(
            height: 40,
            alignment: Alignment.centerLeft,
            child: !widget.showTooltip
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Icon(
                      widget.tooltipIcon,
                      color: widget.tooltipColor,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
