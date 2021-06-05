import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Entities/Currency.ent.dart';
import 'package:rec/Helpers/Formatting.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/routes.dart';

class RechargeOK extends StatefulWidget {
  final double amount;

  const RechargeOK({
    Key key,
    @required this.amount,
  }) : super(key: key);

  @override
  _RechargeOKState createState() => _RechargeOKState();
}

class _RechargeOKState extends State<RechargeOK> {
  Future<bool> _popBackHome() {
    Navigator.of(context).popUntil(ModalRoute.withName(Routes.home));
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _popBackHome,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _body(),
      ),
    );
  }

  Widget _body() {
    var localizations = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(32, 84, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Center(
                child: Text(
                  localizations.translate('RECHARGE_OK', params: {
                    // TODO: refactor currency formatting
                    'amount': Formatting.formatCurrency(
                      (widget.amount / pow(10, Currency.eur.scale)),
                    ),
                  }),
                  style: TextStyles.pageTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: Text(
                  localizations.translate('RECHARGE_OK_DESC'),
                  style: TextStyles.pageSubtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Center(
            child: Image.asset('assets/recharge-ok.png'),
          ),
          RecActionButton(
            label: localizations.translate('ALRIGHT'),
            onPressed: _popBackHome,
          )
        ],
      ),
    );
  }
}
