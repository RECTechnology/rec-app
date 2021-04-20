import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rec/Components/CircleAvatar.dart';
import 'package:rec/Components/InfoColumn.dart';
import 'package:rec/Components/Wallet/Transactions/TransactionAmount.dart';
import 'package:rec/Components/Wallet/Transactions/TransactionIcon.dart';
import 'package:rec/Components/Wallet/Transactions/TransactionTitle.dart';
import 'package:rec/Entities/Transactions/Transaction.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class TransactionDetailsModal {
  final BuildContext context;
  TransactionDetailsModal(this.context);

  void open(Transaction transaction) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.55,
          child: _dialogContent(transaction),
        ),
      ),
    );
  }

  Widget _dialogContent(Transaction transaction) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _txDetailsBody(transaction),
    );
  }

  Widget _txDetailsBody(Transaction transaction) {
    return Column(
      children: [
        _txHeader(transaction),
        _txDate(transaction),
        Flexible(
          child: ListView(
            children: [
              _txCard(transaction),
              _txDetails(transaction),
            ],
          ),
        ),
      ],
    );
  }

  Widget _txHeader(Transaction transaction) {
    var userState = UserState.of(context);
    var currentAccount = userState.account;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 55,
            height: 55,
            child: CircleAvatarRec.fromAccount(currentAccount),
          ),
          Icon(
            transaction.isIn() ? Icons.west : Icons.east,
            color: Brand.grayLight2,
          ),
          Container(
            width: 55,
            height: 55,
            child: TransactionIcon(transaction),
          ),
        ],
      ),
    );
  }

  Widget _txDate(Transaction transaction) {
    var localizations = AppLocalizations.of(context);
    var dateString =
        DateFormat('d MMMM yyyy  HH:mm', localizations.locale.languageCode)
            .format(transaction.createdAt);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Text(
          dateString,
          style: TextStyle(color: Brand.primaryColor, fontSize: 16),
        ),
      ),
    );
  }

  Widget _txConcept(Transaction transaction) {
    var localizations = AppLocalizations.of(context);
    var concept = transaction.getConcept();

    return Text(
      localizations.translate(concept.isEmpty ? 'NO_CONCEPT' : concept),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 18,
        color: Brand.grayDark2,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _txCard(Transaction transaction) {
    return Container(
      decoration: BoxDecoration(
        color: Brand.defaultAvatarBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TransactionTitle(transaction, fontSize: 18),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TransactionAmount(
                transaction,
                fontSize: 18,
              ),
            ),
            _txConcept(transaction),
          ],
        ),
      ),
    );
  }

  Widget _txDetails(Transaction transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoColumn(label: 'TX_ID', value: transaction.id),
          InfoColumn(
            label: 'TX_STATUS',
            value: 'STATUS_${transaction.status.toUpperCase()}',
          ),
        ],
      ),
    );
  }
}
