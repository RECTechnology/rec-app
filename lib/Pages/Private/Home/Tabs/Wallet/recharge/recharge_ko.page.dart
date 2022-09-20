import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';

/// This pages shows a message for a failed recharges
class RechargeKO extends StatefulWidget {
  const RechargeKO({Key? key}) : super(key: key);

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
    final recTheme = RecTheme.of(context);
    final assets = recTheme!.assets;

    return Padding(
      padding: EdgeInsets.fromLTRB(32, 84, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Center(
                child: LocalizedText(
                  'RECHARGE_KO',
                  style: recTheme.textTheme.pageTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: LocalizedText(
                  'RECHARGE_KO_DESC',
                  style: recTheme.textTheme.pageSubtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Center(
            child: Image.asset(assets.rechargeKo),
          ),
          RecActionButton(
            label: 'ALRIGHT',
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
