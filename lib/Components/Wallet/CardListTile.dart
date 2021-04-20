import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Components/OutlinedListTile.dart';
import 'package:rec/Entities/CreditCard.dart';
import 'package:rec/Styles/TextStyles.dart';

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
      widget.card.alias,
      style: TextStyles.outlineTileText,
    );

    return OutlinedListTile(
      height: 48,
      onPressed: widget.onPressed,
      children: [
        cardName,
        Icon(
          Icons.arrow_forward_ios_outlined,
          size: 16,
        )
      ],
    );
  }
}
