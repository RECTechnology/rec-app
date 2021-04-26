import 'package:flutter/material.dart';
import 'package:rec/Api/Services/wallet/CardsService.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/Components/OutlinedListTile.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/User/UserBalance.dart';
import 'package:rec/Components/Wallet/CardListTile.dart';
import 'package:rec/Entities/CreditCard.dart';
import 'package:rec/Entities/Forms/RechargeData.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/AttemptRecharge.dart';
import 'package:rec/Pages/Private/Shared/RequestPin.page.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/routes.dart';

class SelectCard extends StatefulWidget {
  final RechargeData rechargeData;
  final CardsService cardsService;

  const SelectCard({
    Key key,
    @required this.rechargeData,
    this.cardsService,
  }) : super(key: key);

  @override
  _SelectCardState createState() => _SelectCardState();
}

class _SelectCardState extends State<SelectCard> {
  CardsService cardsService;
  List<CreditCard> cards = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();

    cardsService = widget.cardsService ?? CardsService();

    loading = true;
    cardsService.list().then((value) {
      setState(() {
        cards = value.items;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrivateAppBar(
        hasBackArrow: true,
        selectAccountEnabled: false,
        size: 160,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: UserBalance(
            balance: widget.rechargeData.amount,
            label: 'TOTAL_RECHARGE',
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    var localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
          child: Text(
            localizations.translate('SELECT_CARD'),
            style: TextStyles.pageTitle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: _newCardTile(),
        ),
        if (loading)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LoadingIndicator(),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 32, right: 32),
            itemCount: cards.length,
            itemBuilder: (ctx, index) {
              return CardListTile(
                card: cards[index],
                onPressed: () => _selectCardAndMoveForwards(cards[index]),
              );
            },
            physics: AlwaysScrollableScrollPhysics(),
          ),
        )
      ],
    );
  }

  Widget _newCardTile() {
    var localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: OutlinedListTile(
        onPressed: _goToAddNewCard,
        children: [
          Row(
            children: [
              Icon(
                Icons.add_box_outlined,
                size: 20.0,
              ),
              SizedBox(width: 8),
              Text(
                localizations.translate('PAY_WITH_NEW_CARD'),
                style: TextStyles.outlineTileText,
              )
            ],
          )
        ],
      ),
    );
  }

  void _goToAddNewCard() async {
    widget.rechargeData.card = null;
    var saveCard = await Navigator.of(context).pushNamed(Routes.newCard);
    widget.rechargeData.saveCard = saveCard;

    await _askForPin();
  }

  void _selectCardAndMoveForwards(CreditCard card) async {
    widget.rechargeData.card = card;
    await _askForPin();
  }

  Future<dynamic> _askForPin() {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RequestPin(
          ifPin: (pin) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => AttemptRecharge(
                  data: widget.rechargeData..pin = pin,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
