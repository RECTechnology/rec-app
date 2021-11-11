import 'package:flutter/material.dart';
import 'package:rec/Components/Icons/RecCurrencyIcon.dart';
import 'package:rec/Entities/Transactions/Currency.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';

class UserBalance extends StatefulWidget {
  final double balance;
  final String label;
  final Color color;
  final Currency currency;

  UserBalance({
    this.label = 'TOTAL_BALANCE',
    this.color,
    double balance = 0,
    Currency currency,
  })  : balance = balance ?? 0,
        currency = currency ?? Currency.rec;

  @override
  State<StatefulWidget> createState() {
    return _UserBalance();
  }
}

class _UserBalance extends State<UserBalance> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var amount = Currency.format(
      widget.balance,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 40,
                    color: widget.color ?? Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RecCurrencyIcon(color: widget.color),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              localizations.translate(widget.label),
              style: TextStyle(
                fontSize: 15,
                color: widget.color ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
