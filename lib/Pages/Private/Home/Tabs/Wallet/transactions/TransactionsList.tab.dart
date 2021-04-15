import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/Components/Wallet/TransactionListTile.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/brand.dart';
import 'package:rec/preferences.dart';

class TransactionsList extends StatefulWidget {
  final bool autoReloadEnabled;

  TransactionsList({Key key, this.autoReloadEnabled = true}) : super(key: key);

  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  TransactionProvider _transactionsProvider;
  Timer _refreshTransactionsTimer;
  bool showFilters = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _transactionsProvider ??= TransactionProvider.of(context);

    if (widget.autoReloadEnabled) {
      _refreshTransactionsTimer ??= getRefreshTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _refreshTransactionsTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var transactionsProvider = TransactionProvider.of(context);
    var hasTransactions = transactionsProvider.hasTransactions();
    var hasMoreTx = transactionsProvider.total > transactionsProvider.length;
    var isLoading = transactionsProvider.loading;

    return RefreshIndicator(
      color: Brand.primaryColor,
      onRefresh: transactionsProvider.refresh,
      child: Column(
        children: [
          // Filter bar
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [Text('Transactions'), Icon(Icons.filter_list)],
          //   ),
          // ),
          // Divider(height: 1),
          Expanded(
            child: hasTransactions
                ? ListView.separated(
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (ctx, idx) {
                      if (hasMoreTx && idx == transactionsProvider.length) {
                        return loadMore();
                      }

                      return TransactionsListTile(
                        tx: transactionsProvider.get(idx),
                      );
                    },
                    itemCount:
                        transactionsProvider.length + (hasMoreTx ? 1 : 0),
                    physics: AlwaysScrollableScrollPhysics(),
                  )
                : isLoading
                    ? LoadingIndicator()
                    : noItems(localizations),
          )
        ],
      ),
    );
  }

  Widget loadMore() {
    var transactionsProvider = TransactionProvider.of(context);
    var userState = UserState.of(context);
    var localizations = AppLocalizations.of(context);

    return ListTile(
      tileColor: Brand.defaultAvatarBackground,
      onTap: transactionsProvider.loadMore,
      title: transactionsProvider.loading
          ? LoadingIndicator()
          : Text(
              localizations.translate('LOAD_MORE'),
              style: TextStyle(
                color: Brand.getColorForAccount(userState.account),
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  Widget noItems(localizations) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          localizations.translate('NO_TRANSACTIONS'),
        ),
      ),
    );
  }

  Timer getRefreshTimer() {
    // Run refresh directly, no need to wait for timer
    _transactionsProvider?.refresh();

    return Timer.periodic(
      Preferences.transactionListRefreshInterval,
      (_) {
        _transactionsProvider?.refresh();
      },
    );
  }
}
