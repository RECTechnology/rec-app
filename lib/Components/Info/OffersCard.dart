import 'package:flutter/material.dart';
import 'package:rec/Entities/Offer.ent.dart';
import 'package:rec/brand.dart';

class OffersCard extends StatefulWidget {
  final Offer offerData;

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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Brand.defaultAvatarBackground,
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    widget.offerData.image != '' ? widget.offerData.image : 'https://picsum.photos/250?image=9'),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.local_offer,
                color: Brand.grayLight2,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                widget.offerData.description,
                style: TextStyle(
                  color: Brand.grayDark,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                widget.offerData.initialPrice.toString(),
                style: TextStyle(
                  color: Brand.grayDark,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
