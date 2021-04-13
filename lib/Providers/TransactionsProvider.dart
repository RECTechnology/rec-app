import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Services/TransactionsService.dart';
import 'package:rec/Entities/Transactions/Transaction.ent.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  int _total = 0;
  bool hasRequested = false;
  bool loading = false;

  final TransactionsService txService;

  int _limit = 10;
  int _offset = 0;

  TransactionProvider(this.txService);

  static TransactionProvider of(context) {
    return Provider.of<TransactionProvider>(context);
  }

  static ChangeNotifierProvider<TransactionProvider> getProvider(
      TransactionsService txService) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(txService),
    );
  }

  bool hasTransactions() {
    return _transactions.isNotEmpty;
  }

  Transaction get(int index) {
    return _transactions[index];
  }

  int get length {
    return _transactions.length;
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

  List<Transaction> get transactions {
    return _transactions;
  }

  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  int get total {
    return _total;
  }

  void setTotal(int total) {
    _total = total;
  }

  int get offset {
    return _offset;
  }

  void setOffset(int offset) {
    _offset = offset;
    refresh().then((value) => notifyListeners());
  }

  int get limit {
    return _limit;
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
