import 'package:flutter/material.dart';
import 'package:rec/Components/Info/OffersCard.dart';
import 'package:rec/Entities/Offer.ent.dart';
import 'package:rec/brand.dart';

class OffersList extends StatefulWidget {
  final List<Offer> offers;

  OffersList({Key key, this.offers}) : super(key: key);

  @override
  _OffersListState createState() => _OffersListState();
}

class _OffersListState extends State<OffersList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Brand.defaultAvatarBackground,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: widget.offers
              .map(
                (offer) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: OffersCard(offer),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
