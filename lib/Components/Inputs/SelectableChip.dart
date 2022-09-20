import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';

class SelectableChip extends StatefulWidget {
  final bool isSelected;
  final String label;
  final ValueChanged<bool>? onSelected;
  final EdgeInsets padding;

  SelectableChip({
    Key? key,
    required this.label,
    this.isSelected = false,
    this.onSelected,
    this.padding = const EdgeInsets.only(right: 8),
  }) : super(key: key);

  @override
  _SelectableChipState createState() => _SelectableChipState();
}

class _SelectableChipState extends State<SelectableChip> {
  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    
    return Padding(
      padding: widget.padding,
      child: FilterChip(
        backgroundColor: Colors.white,
        selectedColor: Colors.white,
        checkmarkColor: recTheme!.accentColor,
        elevation: 1,
        label: LocalizedText(
          widget.label,
          style: TextStyle(
            color: widget.isSelected ? recTheme.accentColor : recTheme.grayDark2,
            fontSize: 12,
          ),
        ),
        selected: widget.isSelected,
        onSelected: widget.onSelected,
      ),
    );
  }
}
