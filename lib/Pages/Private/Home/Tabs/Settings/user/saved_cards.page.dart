import 'package:flutter/material.dart';
import 'package:rec/Components/Icons/credit_card_type_icon.dart';
import 'package:rec/Components/Modals/YesNoModal.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class SavedCardsPage extends StatefulWidget {
  SavedCardsPage({Key? key}) : super(key: key);

  @override
  State<SavedCardsPage> createState() => _SavedCardsPageState();
}

class _SavedCardsPageState extends State<SavedCardsPage> {
  final _accountsService = AccountsService(env: env);

  @override
  Widget build(BuildContext context) {
    final user = UserState.of(context).user;
    final cards = user!.bankCards;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(context, title: 'SAVED_CARDS'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CaptionText('SAVED_CARD_DESC'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: LocalizedText('AVAILABLE_CARDS'),
          ),
          if (cards.isEmpty)
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.credit_card_off),
                    title: LocalizedText('NO_CARDS_SAVED'),
                  ),
                ],
              ),
            ),
          if (cards.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) {
                  if (cards[index].deleted) return SizedBox.shrink();
                  
                  return ListTile(
                    leading: CreditCardTypeIcon(alias: cards[index].alias),
                    title: LocalizedText(cards[index].alias),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteCard(cards[index]);
                      },
                      splashRadius: 24,
                    ),
                  );
                },
                itemCount: cards.length,
              ),
            ),
        ],
      ),
    );
  }

  void _deleteCard(BankCard card) async {
    final confirmationModal = YesNoModal(
      context: context,
      title: LocalizedText('DELETE_CARD'),
      content: LocalizedText('DELETE_CARD_DESC', params: {'card': card.alias}),
    );

    final deleteCard = await confirmationModal.showDialog(context);

    if (deleteCard == true) {
      Loading.show();
      _accountsService.deleteBankCardAccount(card.id as String).then((value) {
        RecToast.showSuccess(context, 'DELETED_CARD');
        UserState.deaf(context).getUser();
      }).catchError((e) {
        RecToast.showSuccess(context, e.message);
      }).whenComplete(() => Loading.dismiss());
    }
  }
}
