import 'package:flutter/material.dart';
import 'package:rec/Components/Icons/RecCurrencyIcon.dart';
import 'package:rec/Entities/Transactions/Currency.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/PreferenceProvider.dart';
import 'package:rec/Providers/Preferences/PreferenceDefinitions.dart';

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
  PreferenceProvider prefProvider;
  bool showBalance = true;

  @override
  void initState() {
    prefProvider = PreferenceProvider.deaf(context);
    showBalance = prefProvider.get(PreferenceKeys.showWalletBalance) ?? true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var amount = showBalance ? Currency.format(widget.balance) : '* * *';
    var subtitle = showBalance ? localizations.translate(widget.label) : '';

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
                _showHideButton(),
                InkWell(
                  onTap: _toggleBalanceVisibility,
                  child: Text(
                    amount,
                    style: TextStyle(
                      fontSize: 40,
                      color: widget.color ?? Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
              subtitle,
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

  Widget _showHideButton() {
    var localizations = AppLocalizations.of(context);

    return Tooltip(
      message: localizations.translate('WALLET_SHOW_BALANCE_TOOLTIP'),
      child: IconButton(
        icon: Icon(
          showBalance ? Icons.visibility : Icons.visibility_off,
          color: Colors.white,
          size: 16,
        ),
        splashRadius: 24,
        onPressed: _toggleBalanceVisibility,
      ),
    );
  }

  void _toggleBalanceVisibility() {
    prefProvider.set(
      PreferenceKeys.showWalletBalance,
      !showBalance,
    );
    setState(() {
      showBalance = !showBalance;
    });
  }
}
