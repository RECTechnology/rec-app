import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Entities/Offers.ent.dart';

class OffersCard extends StatefulWidget {
  final OffersData offerData;

  const OffersCard(this.offerData);

  @override
  State<StatefulWidget> createState() {
    return _OffersCard();
  }
}

class _OffersCard extends State<OffersCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.offerData.avatarImage != ''
                        ? widget.offerData.avatarImage
                        : 'https://picsum.photos/250?image=9'))),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: Column(
                children: [
                  Text(
                    widget.offerData.description,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
