import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';

class CustomCheckboxTile extends StatelessWidget {
  final bool selected;
  final ValueChanged<bool?> onChanged;
  final String title;
  final Color? backgroundColor;

  const CustomCheckboxTile({
    Key? key,
    required this.selected,
    required this.onChanged,
    required this.title,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: () {
          onChanged(!selected);
        },
        child: Row(
          children: [
            Checkbox(value: selected, onChanged: onChanged),
            LocalizedText(title),
          ],
        ),
      ),
    );
  }
}
