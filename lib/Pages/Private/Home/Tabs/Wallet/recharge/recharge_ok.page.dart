import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/assets.dart';
import 'package:rec/styles/text_styles.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

/// This pages shows a message for a successful recharge
class RechargeOK extends StatefulWidget {
  final double amount;

  const RechargeOK({
    Key? key,
    required this.amount,
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
                  'RECHARGE_OK',
                  params: {
                    'amount': Currency.format(
                      widget.amount,
                    ),
                  },
                  style: TextStyles.pageTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: LocalizedText(
                  'RECHARGE_OK_DESC',
                  style: TextStyles.pageSubtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Center(
            child: Image.asset(Assets.rechargeOk),
          ),
          RecActionButton(
            label: 'ALRIGHT',
            onPressed: _popBackHome,
          )
        ],
      ),
    );
  }
}
