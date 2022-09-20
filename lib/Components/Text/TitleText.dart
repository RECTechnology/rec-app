import 'package:flutter/material.dart';
import 'package:rec/Components/Info/InfoTooltip.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/AppLocalizations.dart';

class TitleText extends StatefulWidget {
  final String title;
  final TextStyle style;
  final MainAxisAlignment alignment;
  final TextAlign textAlign;

  final String tooltipText;
  final bool showTooltip;
  final Color? tooltipColor;
  final IconData tooltipIcon;

  const TitleText(
    this.title, {
    Key? key,
    this.style = const TextStyle(),
    this.showTooltip = false,
    this.tooltipText = '',
    this.tooltipColor,
    this.tooltipIcon = Icons.help_outline,
    this.alignment = MainAxisAlignment.start,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  @override
  _TitleText createState() => _TitleText();
}

class _TitleText extends State<TitleText> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final recTheme = RecTheme.of(context);

    return Row(
      mainAxisAlignment: widget.alignment,
      children: [
        LocalizedText(
          widget.title,
          style: Theme.of(context).textTheme.headline6!.merge(widget.style),
          textAlign: widget.textAlign,
        ),
        InfoTooltip(
          message: localizations!.translate(widget.tooltipText),
          backgroundColor: recTheme!.accentColor,
          child: Container(
            height: 40,
            alignment: Alignment.centerLeft,
            child: !widget.showTooltip
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Icon(
                      widget.tooltipIcon,
                      color: widget.tooltipColor ?? recTheme.grayDark2,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
