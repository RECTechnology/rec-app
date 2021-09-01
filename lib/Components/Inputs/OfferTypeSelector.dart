import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Entities/Offer.ent.dart';
import 'package:rec/brand.dart';

class OfferTypeSelector extends StatelessWidget {
  final OfferType type;
  final ValueChanged<OfferType> onChange;
  final TextStyle selectedStyle;

  const OfferTypeSelector({
    Key key,
    @required this.type,
    @required this.onChange,
    this.selectedStyle = const TextStyle(
      color: Brand.primaryColor,
      fontWeight: FontWeight.bold,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Brand.grayLight2),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTypeLabel(OfferType.classic, 'RECs'),
          _buildTypeLabel(OfferType.percentage, 'PERCENTAGE'),
          _buildTypeLabel(OfferType.free, 'FREE'),
        ],
      ),
    );
  }

  Widget _buildTypeLabel(
    OfferType type,
    String label,
  ) {
    return InkWell(
      onTap: () => onChange(type),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: LocalizedText(
          label,
          style: type == this.type ? selectedStyle : null,
        ),
      ),
    );
  }
}
