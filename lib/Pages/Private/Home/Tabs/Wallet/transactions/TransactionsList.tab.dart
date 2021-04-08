import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/Transactions/TransactionListTile.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/brand.dart';

class TransactionsList extends StatefulWidget {
  TransactionsList({Key key}) : super(key: key);

  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends GenericRecViewScreen<TransactionsList> {
  TransactionProvider transactionsProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var transactionsProvider = TransactionProvider.of(context);
    if (!transactionsProvider.hasRequested) {
      transactionsProvider.refresh();
    }
  }

  @override
  Widget buildPageContent(
    BuildContext context,
    AppState appState,
    UserState userState,
    AppLocalizations localizations,
  ) {
    var transactionsProvider = TransactionProvider.of(context);
    var hasTransactions = transactionsProvider.hasTransactions();

    return RefreshIndicator(
      color: Brand.primaryColor,
      onRefresh: transactionsProvider.refresh,
      child: hasTransactions
          ? ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Brand.separatorColor,
                height: 1,
              ),
              itemBuilder: (ctx, idx) => TransactionsListTile(
                tx: transactionsProvider.get(idx),
              ),
              itemCount: transactionsProvider.length,
              physics: AlwaysScrollableScrollPhysics(),
            )
          : noItems(localizations),
    );
  }

  Widget noItems(localizations) {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              localizations.translate('NO_ITEMS'),
            ),
          ),
        )
      ],
    );
  }
}
