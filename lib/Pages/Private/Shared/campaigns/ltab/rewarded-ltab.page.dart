import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class LtabRewardedPage extends StatefulWidget {
  final double amount;

  const LtabRewardedPage({
    Key? key,
    required this.amount,
  }) : super(key: key);

  @override
  _LtabRewardedPageState createState() => _LtabRewardedPageState();
}

class _LtabRewardedPageState extends State<LtabRewardedPage> {
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
    final activeCampaign = CampaignProvider.of(context).getCampaignByCode(env.CMP_LTAB_CODE);
    final recTheme = RecTheme.of(context);

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
                  style: recTheme!.textTheme.pageTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: LocalizedText(
                  'REWARD_OBTAINED',
                  style: recTheme.textTheme.pageTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: LocalizedText(
                  'REWARD_OBTAINED_DESC',
                  params: {
                    'amount': Currency.format(
                      widget.amount,
                    ),
                  },
                  style: recTheme.textTheme.pageSubtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              height: 194,
              width: 194,
              child: Image.network(activeCampaign!.imageUrl!),
            ),
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
