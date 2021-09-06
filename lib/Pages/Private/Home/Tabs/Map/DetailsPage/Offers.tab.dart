import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/OfferPreviewTile.dart';
import 'package:rec/Components/Lists/ScrollableList.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Helpers/Checks.dart';

class OffersTab extends StatefulWidget {
  final Account account;

  const OffersTab({Key key, this.account}) : super(key: key);

  @override
  _OffersTabState createState() => _OffersTabState();
}

class _OffersTabState extends State<OffersTab> {
  @override
  Widget build(BuildContext context) {
    var offers = widget.account.offers;

    return ScrollableList(
      children: [
        if (Checks.isEmpty(offers))
          Padding(
            padding: EdgeInsets.all(16),
            child: LocalizedText('NO_OFFERS'),
          ),
        if (Checks.isNotEmpty(offers))
          ...offers.map(
            (e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: OfferPreviewTile(
                key: Key(e.id.toString()),
                offer: e,
              ),
            ),
          ),
      ],
    );
  }
}
