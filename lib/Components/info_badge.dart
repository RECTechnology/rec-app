import 'package:flutter/material.dart';
import 'package:rec/Components/boxes.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';

class InfoBadge extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const InfoBadge({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GrayBox(
      height: null,
      child: child,
      padding: padding,
    );
  }
}

class LabelValueBadge extends StatelessWidget {
  final String label;
  final String value;

  final Map<String, String> labelParams;
  final Map<String, String> valueParams;

  const LabelValueBadge({
    Key? key,
    required this.label,
    required this.value,
    this.labelParams = const {},
    this.valueParams = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final recTheme = RecTheme.of(context);

    return InfoBadge(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          LocalizedText(label, style: textTheme.caption, params: labelParams),
          const SizedBox(width: 8),
          LocalizedText(
            value,
            style: textTheme.caption!.copyWith(
              color: recTheme!.grayDark,
              fontWeight: FontWeight.bold,
            ),
            params: valueParams,
          ),
        ],
      ),
    );
  }
}
