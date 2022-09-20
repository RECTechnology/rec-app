import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class OfferTypeSelector extends StatelessWidget {
  final OfferType type;
  final ValueChanged<OfferType> onChange;
  final TextStyle selectedStyle;

  const OfferTypeSelector({
    Key? key,
    required this.type,
    required this.onChange,
    this.selectedStyle = const TextStyle(
      fontWeight: FontWeight.bold,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: recTheme!.grayLight2),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTypeLabel(OfferType.classic, 'RECs', recTheme),
          _buildTypeLabel(OfferType.percentage, 'PERCENTAGE', recTheme),
          _buildTypeLabel(OfferType.free, 'FREE', recTheme),
        ],
      ),
    );
  }

  Widget _buildTypeLabel(
    OfferType type,
    String label,
    RecThemeData theme,
  ) {
    return InkWell(
      onTap: () => onChange(type),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: LocalizedText(
          label,
          style: type == this.type ? selectedStyle.copyWith(color: theme.primaryColor) : null,
        ),
      ),
    );
  }
}
