import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/Components/ListTiles/TransactionListTile.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/providers/transactions_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/preferences.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class TransactionsList extends StatefulWidget {
  final bool autoReloadEnabled;

  TransactionsList({Key? key, this.autoReloadEnabled = true}) : super(key: key);

  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  TransactionProvider? _transactionsProvider;
  Timer? _refreshTransactionsTimer;
  bool showFilters = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_transactionsProvider == null) {
      _transactionsProvider = TransactionProvider.of(context);
      _transactionsProvider!.refresh();
    }

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

    var color = userState.getColor(defaultColor: Brand.primaryColor);
    var hasTransactions = transactionsProvider.hasTransactions;
    var hasMoreTx = transactionsProvider.total! > transactionsProvider.length;
    var isLoading = transactionsProvider.loading;
    var itemCount = transactionsProvider.length + (hasMoreTx ? 1 : 0);

    return RefreshIndicator(
      color: color,
      onRefresh: transactionsProvider.refresh,
      child: Column(
        children: [
          // TextButton(
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       QualifyComercePage.getRoute(userState.account!),
          //     );
          //   },
          //   child: Text('open qualig'),
          // ),
          Expanded(
            child: Scrollbar(
              thickness: 8,
              trackVisibility: true,
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
                      itemCount: itemCount,
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

    return ListTile(
      tileColor: Brand.defaultAvatarBackground,
      onTap: transactionsProvider.loadMore,
      title: transactionsProvider.loading
          ? LoadingIndicator()
          : LocalizedText(
              'LOAD_MORE',
              style: TextStyle(
                color: Brand.getColorForAccount(userState.account as Account),
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
