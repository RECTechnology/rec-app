import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/AmountTextField.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/User/UserBalance.dart';
import 'package:rec/Entities/Forms/RechargeData.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/SelectCard.page.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class RechargePage extends StatefulWidget {
  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  final _formKey = GlobalKey<FormState>();
  RechargeData rechargeData = RechargeData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrivateAppBar(
        hasBackArrow: true,
        selectAccountEnabled: false,
        size: 160,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: UserBalance(
            balance: rechargeData.amount,
            label: 'TOTAL_RECHARGE',
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    var localizations = AppLocalizations.of(context);

    return Container(
      padding: Paddings.page,
      child: Column(
        children: [
          Text(
            localizations.translate('RECHARGE_DESC'),
            style: TextStyle(
              fontSize: 13,
              color: Brand.grayDark2,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 16),
                AmountTextField(
                  onChange: (v) {
                    setState(() => rechargeData.amount = double.parse(v));
                  },
                ),
                SizedBox(height: 32),
                RecActionButton(
                  label: localizations.translate('RECHARGE'),
                  icon: Icons.arrow_forward_ios_sharp,
                  onPressed: rechargeData.amount >= 1 ? _goToSelectCard : null,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToSelectCard() async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => SelectCard(rechargeData: rechargeData),
      ),
    );

    if (result != null) {
      setState(() => rechargeData = result);
    }
  }
}
