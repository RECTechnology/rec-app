import 'package:flutter/material.dart';
import 'package:rec/Components/Layout/ScrollableListLayout.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Components/ListTiles/OfferPreviewTile.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/offers/AddOffer.page.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class AccountOffersPage extends StatefulWidget {
  AccountOffersPage({Key key}) : super(key: key);

  @override
  _AccountOffersPageState createState() => _AccountOffersPageState();
}

class _AccountOffersPageState extends State<AccountOffersPage> {
  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var offers = userState.account.offers;

    return ScrollableListLayout(
      appBar: EmptyAppBar(
        context,
        title: 'BUSSINESS_OFFERS',
      ),
      backgroundColor: Colors.white,
      header: Container(
        color: Brand.defaultAvatarBackground,
        padding: EdgeInsets.symmetric(vertical: 16),
        child: GeneralSettingsTile(
          title: 'PUBLISH_OFFER',
          subtitle: 'PUBLISH_OFFER_DESC',
          onTap: _newOffer,
        ),
      ),
      children: [
        SectionTitleTile.gray('ACTIVE_OFFERS'),
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

  void _newOffer() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) {
        return AddOfferPage();
      }),
    ).then(_addedNewOffer);
  }

  void _addedNewOffer(offer) {
    if (offer != null) {
      var userState = UserState.of(context, listen: false);
      userState.getUser();
    }
  }
}
