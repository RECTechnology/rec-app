import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Entities/Transactions/Currency.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/CampaignProvider.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/routes.dart';

class LtabRewarded extends StatefulWidget {
  final double amount;

  const LtabRewarded({
    Key key,
    @required this.amount,
  }) : super(key: key);

  @override
  _LtabRewardedState createState() => _LtabRewardedState();
}

class _LtabRewardedState extends State<LtabRewarded> {
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
    var activeCampaign = CampaignProvider.of(context).activeCampaign;

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
                  'PURCHASE_DONE',
                  style: TextStyles.pageTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: LocalizedText(
                  'REWARD_OBTAINED',
                  style: TextStyles.pageTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: Text(
                  localizations.translate(
                    'REWARD_OBTAINED_DESC',
                    params: {
                      'amount': Currency.format(
                        widget.amount,
                      ),
                    },
                  ),
                  style: TextStyles.pageSubtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              height: 194,
              width: 194,
              child: Image.network(activeCampaign.imageUrl),
            ),
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
