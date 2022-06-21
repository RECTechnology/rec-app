import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/OutlinedListTile.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

import 'save_card.page.dart';

/// This page asks the user to select a saved [BankCard] or a new bank card
///
/// It can pop with:
/// * [BankCard] -> If the user selects a saved [BankCard]
/// * [bool] -> If the user wants to add a new card ([bool] indicates if the user wants to save the new card or not)
/// * [null] -> if the user does not select any option and clicks the back button
class SelectCardPage extends StatelessWidget {
  SelectCardPage({Key? key, required this.rechargeData}) : super(key: key);

  final RechargeData rechargeData;

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
            balance: rechargeData.amount,
            label: 'TOTAL_RECHARGE',
          ),
        ),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    final user = UserState.of(context).user;
    final bankCards = user?.bankCards ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocalizedText(
              'SELECT_CARD',
              style: TextStyle(
                fontSize: 20,
                color: Brand.grayDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            _newCardButton(context),
            ...bankCards.map(
              (card) => CardTile(
                onPressed: () {
                  Navigator.of(context).pop(card);
                },
                card: card,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _newCardButton(BuildContext context) {
    return OutlinedListTile(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      onPressed: () {
        RecNavigation.of(context)
            .navigate((_) => SaveCardPage())
            .then((value) => Navigator.pop(context, value));
      },
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(Icons.add),
        ),
        LocalizedText(
          'NEW_CARD',
          style: Theme.of(context).textTheme.button!.copyWith(color: Brand.grayDark, fontSize: 16),
        ),
        const SizedBox(),
      ],
    );
  }
}

class CardTile extends StatelessWidget {
  const CardTile({
    Key? key,
    required this.card,
    required this.onPressed,
  }) : super(key: key);

  final BankCard card;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedListTile(
      onPressed: onPressed,
      children: [
        Text(
          card.alias,
          style: Theme.of(context).textTheme.button!.copyWith(
                color: Brand.primaryColor,
                fontSize: 16,
              ),
        ),
      ],
      color: Brand.primaryColor,
    );
  }
}
