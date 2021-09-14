import 'package:flutter/material.dart';
import 'package:rec/Api/Services/OffersService.dart';
import 'package:rec/Components/Layout/ScrollableListLayout.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Components/ListTiles/OfferPreviewTile.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/Modals/YesNoModal.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Entities/Offer.ent.dart';
import 'package:rec/Entities/User.ent.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/offers/AddOffer.page.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class AccountOffersPage extends StatefulWidget {
  AccountOffersPage({Key key}) : super(key: key);

  @override
  _AccountOffersPageState createState() => _AccountOffersPageState();
}

class _AccountOffersPageState extends State<AccountOffersPage> {
  final _offerService = OffersService();

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
            (offer) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: OfferPreviewTile(
                key: Key(offer.id.toString()),
                offer: offer,
                onDelete: () => _onDelete(offer),
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

  Future<User> _addedNewOffer(dynamic offer) {
    var userState = UserState.of(context, listen: false);
    return userState.getUser();
  }

  void _onDelete(Offer offer) async {
    var yesNoModal = YesNoModal(
      title: LocalizedText('DELETE_OFFER'),
      content: LocalizedText('DELETE_OFFER_DESC'),
      context: context,
    );
    var removeOfferConfirmed = await yesNoModal.showDialog(context);
    if (removeOfferConfirmed) {
      _deleteOffer(offer);
    }
  }

  void _deleteOffer(Offer offer) {
    Loading.show();
    _offerService
        .deleteOffer(offer.id)
        .then((res) => _addedNewOffer(null))
        .then(_offerRemoved)
        .catchError(_onError);
  }

  void _offerRemoved(res) {
    RecToast.showError(context, 'OFFER_REMOVED_OK');
    Loading.dismiss();
  }

  void _onError(err) {
    Loading.dismiss();
    RecToast.showError(context, err.toString());
  }
}
