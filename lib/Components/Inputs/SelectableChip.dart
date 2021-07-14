import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/brand.dart';

class SelectableChip extends StatefulWidget {
  final bool isSelected;
  final String label;

  final ValueChanged<bool> onSelected;

  SelectableChip({
    Key key,
    this.isSelected,
    this.label,
    this.onSelected,
  }) : super(key: key);

  @override
  _SelectableChipState createState() => _SelectableChipState();
}

class _SelectableChipState extends State<SelectableChip> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        backgroundColor: Colors.white,
        selectedColor: Colors.white,
        checkmarkColor: Brand.accentColor,
        elevation: 1,
        label: LocalizedText(
          widget.label,
          style: TextStyle(
            color: widget.isSelected ? Brand.accentColor : Brand.grayDark2,
            fontSize: 12,
          ),
        ),
        selected: widget.isSelected,
        onSelected: widget.onSelected,
      ),
    );
  }
}
