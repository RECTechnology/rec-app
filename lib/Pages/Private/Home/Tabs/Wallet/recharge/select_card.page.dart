import 'package:flutter/material.dart';
import 'package:rec/Components/Icons/credit_card_type_icon.dart';
import 'package:rec/Components/ListTiles/OutlinedListTile.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Wallet/user_balance.dart';
import 'package:rec/config/theme.dart';
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
    final recTheme = RecTheme.of(context);

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
                color: recTheme!.grayDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            _newCardButton(context),
            ...bankCards.where((card) => !card.deleted).map(
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
    final recTheme = RecTheme.of(context);

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
          padding: const EdgeInsets.only(right: 12.0),
          child: Icon(Icons.add),
        ),
        LocalizedText(
          'NEW_CARD',
          style:
              Theme.of(context).textTheme.button!.copyWith(color: recTheme!.grayDark, fontSize: 16),
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
    final recTheme = RecTheme.of(context);
    
    return OutlinedListTile(
      onPressed: onPressed,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CreditCardTypeIcon(
          alias: card.alias,
          size: 24,
          color: recTheme!.primaryColor,
        ),
        const SizedBox(width: 12),
        Text(
          card.alias,
          style: Theme.of(context).textTheme.button!.copyWith(
                color: recTheme.primaryColor,
                fontSize: 16,
              ),
        ),
      ],
      color: recTheme.primaryColor,
    );
  }
}
