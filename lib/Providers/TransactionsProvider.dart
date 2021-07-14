import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Services/wallet/TransactionsService.dart';
import 'package:rec/Entities/Transactions/Transaction.ent.dart';

/// [TransactionProvider] contains list of transactions for current user
/// aswell as methods to fetch and filter
class TransactionProvider with ChangeNotifier {
  static TransactionProvider of(context, {bool listen = true}) {
    return Provider.of<TransactionProvider>(context, listen: listen);
  }

  static ChangeNotifierProvider<TransactionProvider> getProvider(
    TransactionsService txService,
  ) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(txService),
    );
  }

  final TransactionsService txService;

  List<Transaction> _transactions = [];
  int _total = 0;
  int _limit = 10;
  int _offset = 0;

  /// Indicates whether this provider has requested any data yet
  bool hasRequested = false;

  /// Indicates whether this provider is loading data or not
  bool loading = false;

  List<Transaction> get transactions => _transactions;
  int get length => _transactions.length;
  int get total => _total;
  int get offset => _offset;
  int get limit => _limit;
  bool get hasTransactions => _transactions.isNotEmpty;

  TransactionProvider(this.txService);

  Transaction get(int index) {
    return _transactions[index];
  }

  Future<void> loadData() {
    return txService.list(offset: _offset, limit: _limit).then((value) {
      _transactions = value.items;
      _total = value.total;
      loading = false;
    }).catchError((e) {
      loading = false;
    });
  }

  Future<void> refresh() {
    hasRequested = true;
    loading = true;
    return loadData().then((value) => notifyListeners());
  }

  void clear() {
    _transactions = [];
    _total = 0;
    _limit = 10;
    _offset = 0;
    hasRequested = false;
    loading = false;
  }

  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  void setTotal(int total) {
    _total = total;
  }

  void setOffset(int offset) {
    _offset = offset;
    refresh().then((value) => notifyListeners());
  }

  void setLimit(int limit) {
    _limit = limit;
    refresh().then((value) => notifyListeners());
  }

  void loadMore() {
    if (length < total) {
      setLimit(limit + 10);
    }
  }
}
