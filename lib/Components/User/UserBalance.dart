import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Entities/Currency.ent.dart';
import 'package:rec/Helpers/Formatting.dart';
import 'package:rec/Providers/AppLocalizations.dart';

class UserBalance extends StatefulWidget {
  final double balance;
  final Currency currency;
  final String label;

  UserBalance({
    this.balance,
    this.label = 'TOTAL_BALANCE',
    Currency currency,
  }) : currency = currency ?? Currency.rec;

  @override
  State<StatefulWidget> createState() {
    return _UserBalance();
  }
}

class _UserBalance extends State<UserBalance> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var amount = Formatting.formatCurrency(
      widget.balance,
      symbol: widget.currency.symbol,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              localizations.translate(widget.label).toUpperCase(),
              style: TextStyle(fontSize: 15, color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }
}
