import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/OfferPreviewTile.dart';
import 'package:rec/Components/Lists/ScrollableList.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class OffersTab extends StatefulWidget {
  final Account? account;
  final ScrollController? scrollController;

  const OffersTab({Key? key, this.account, this.scrollController})
      : super(key: key);

  @override
  _OffersTabState createState() => _OffersTabState();
}

class _OffersTabState extends State<OffersTab> {
  @override
  Widget build(BuildContext context) {
    var offers = widget.account!.activeOffers;

    return ScrollableList(
      scrollController: widget.scrollController,
      children: [
        if (Checks.isEmpty(offers))
          Padding(
            padding: EdgeInsets.all(16),
            child: LocalizedText('NO_OFFERS'),
          ),
        if (Checks.isNotEmpty(offers))
          ...offers!.map(
            (e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: OfferPreviewTile(
                key: Key(e.id.toString()),
                offer: e,
                hasActions: false,
              ),
            ),
          ),
      ],
    );
  }
}
