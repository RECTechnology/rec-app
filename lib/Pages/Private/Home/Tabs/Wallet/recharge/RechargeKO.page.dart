import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/TextStyles.dart';

class RechargeKO extends StatefulWidget {
  const RechargeKO({Key key}) : super(key: key);

  @override
  _RechargeKOState createState() => _RechargeKOState();
}

class _RechargeKOState extends State<RechargeKO> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
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
                  localizations.translate('RECHARGE_KO'),
                  style: TextStyles.pageTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: Text(
                  localizations.translate('RECHARGE_KO_DESC'),
                  style: TextStyles.pageSubtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Center(
            child: Image.asset('assets/recharge-ko.png'),
          ),
          RecActionButton(
            label: localizations.translate('ALRIGHT'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
