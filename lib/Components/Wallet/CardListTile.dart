import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Components/OutlinedListTile.dart';
import 'package:rec/Entities/CreditCard.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';

class CardListTile extends StatefulWidget {
  final CreditCard card;
  final Function() onPressed;

  const CardListTile({
    Key key,
    @required this.card,
    this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CardListTile();
  }
}

class _CardListTile extends State<CardListTile> {
  @override
  Widget build(BuildContext context) {
    var cardName = Text(
      widget.card.formattedAlias,
      style: TextStyles.outlineTileText.copyWith(
        color: Brand.primaryColor,
      ),
    );

    return OutlinedListTile(
      height: 48,
      onPressed: widget.onPressed,
      color: Brand.primaryColor,
      children: [
        Row(children: [
          widget.card.cardTypeAsset,
          const SizedBox(width: 16),
          cardName
        ]),
      ],
    );
  }
}
