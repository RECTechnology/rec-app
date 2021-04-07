import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Entities/Transaction.ent.dart';

class TransactionsListTile extends StatefulWidget {
  final Transaction tx;

  const TransactionsListTile({Key key, this.tx}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TransactionsListTile();
  }
}

class _TransactionsListTile extends State<TransactionsListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.tx.id),
    );
  }
}
