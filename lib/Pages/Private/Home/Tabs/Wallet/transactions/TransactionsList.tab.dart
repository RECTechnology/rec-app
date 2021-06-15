import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/Components/ListTiles/TransactionListTile.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Providers/AppLocalizations.dart';
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
    var transactionsProvider = TransactionProvider.of(context);
    var userState = UserState.of(context);

    var hasTransactions = transactionsProvider.hasTransactions();
    var hasMoreTx = transactionsProvider.total > transactionsProvider.length;
    var isLoading = transactionsProvider.loading;

    var color = userState.getColor(defaultColor: Brand.primaryColor);

    return RefreshIndicator(
      color: color,
      onRefresh: transactionsProvider.refresh,
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              thickness: 8,
              showTrackOnHover: true,
              radius: Radius.circular(3),
              child: hasTransactions
                  ? ListView.separated(
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (ctx, idx) {
                        if (hasMoreTx && idx == transactionsProvider.length) {
                          return _loadMore();
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
                      : ListView(children: [_noItems()]),
            ),
          )
        ],
      ),
    );
  }

  Widget _loadMore() {
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

  Widget _noItems() {
    return ListTile(
      title: Center(
        child: LocalizedText(
          'NO_TRANSACTIONS',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }

  Timer getRefreshTimer() {
    // Run refresh directly, no need to wait for first timer call
    _transactionsProvider?.refresh();

    return Timer.periodic(
      Preferences.transactionListRefreshInterval,
      (_) {
        _transactionsProvider?.refresh();
      },
    );
  }
}
