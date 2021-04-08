import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Services/TransactionsService.dart';
import 'package:rec/Entities/Transaction.ent.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  int _total = 0;
  bool hasRequested = false;

  TransactionsService txs = TransactionsService();

  static TransactionProvider of(context) {
    return Provider.of<TransactionProvider>(context);
  }

  static ChangeNotifierProvider<TransactionProvider> getProvider() {
    return ChangeNotifierProvider(create: (context) => TransactionProvider());
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

  Future<void> refresh() {
    hasRequested = true;
    return txs.list().then((value) {
      setTransactions(value.items);
      setTotal(value.total);
    }).catchError((e) {
      print(e);
    });
  }

  int get total {
    return _total;
  }

  List<Transaction> get transactions {
    return _transactions;
  }

  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  void setTotal(int total) {
    _total = total;
  }
}
