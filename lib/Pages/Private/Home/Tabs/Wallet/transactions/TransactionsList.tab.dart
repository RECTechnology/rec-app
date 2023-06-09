import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/Components/ListTiles/TransactionListTile.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/transactions_provider.dart';
import 'package:rec/providers/user_state.dart';
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
    final transactionsProvider = TransactionProvider.of(context);
    final userState = UserState.of(context);
    final recTheme = RecTheme.of(context);

    final color = recTheme!.accountTypeColor(userState.account?.type ?? Account.TYPE_PRIVATE);
    final hasTransactions = transactionsProvider.hasTransactions;
    final hasMoreTx = transactionsProvider.total! > transactionsProvider.length;
    final isLoading = transactionsProvider.loading;
    final itemCount = transactionsProvider.length + (hasMoreTx ? 1 : 0);
    final isKyc2 = userState.account?.hasLevelByCode(Level.CODE_KYC2) == true;
    final isKyc3 = userState.account?.hasLevelByCode(Level.CODE_KYC3) == true;
    final isNotKycValidated = !isKyc2 && !isKyc3;
    final isCommerce = userState.account?.isCompany() == true;

    return Theme(
      //Inherit the current Theme and override only the accentColor property
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: color,
        ),
      ),
      child: RefreshIndicator(
        color: color,
        onRefresh: transactionsProvider.refresh,
        child: Column(
          children: [
            if (isNotKycValidated && isCommerce && false)
              Container(
                height: 80,
                padding: EdgeInsets.all(12).copyWith(left: 16, right: 16),
                color: recTheme.red,
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    const SizedBox(width: 16),
                    Flexible(
                      child: LocalizedText(
                        'NOT_KYC2_ACCOUNT_DESC',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
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
      ),
    );
  }

  Widget _loadMore() {
    final transactionsProvider = TransactionProvider.of(context);
    final userState = UserState.of(context);
    final recTheme = RecTheme.of(context);

    final color = recTheme!.accountTypeColor(userState.account?.type ?? Account.TYPE_PRIVATE);

    return ListTile(
      tileColor: recTheme.defaultAvatarBackground,
      onTap: transactionsProvider.loadMore,
      title: transactionsProvider.loading
          ? LoadingIndicator()
          : LocalizedText(
              'LOAD_MORE',
              style: TextStyle(color: color),
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
