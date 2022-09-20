import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LinkText.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/config/routes.dart';

class LtabWelcomePage extends StatefulWidget {
  const LtabWelcomePage({Key? key}) : super(key: key);

  @override
  _LtabWelcomePageState createState() => _LtabWelcomePageState();
}

class _LtabWelcomePageState extends State<LtabWelcomePage> {
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
        appBar: EmptyAppBar(context),
        body: SingleChildScrollView(
          child: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    final activeCampaign = CampaignProvider.of(context).getCampaignByCode(env.CMP_LTAB_CODE);
    final recTheme = RecTheme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(32, 24, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Center(
                child: LocalizedText(
                  'ALREADY_A_PART_OF',
                  params: {
                    'campaign': activeCampaign!.name!.toUpperCase(),
                  },
                  style: recTheme!.textTheme.pageTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: LocalizedText(
                  'CAMPAIGN_WELCOME_DESC',
                  style: recTheme.textTheme.pageSubtitle1,
                  textAlign: TextAlign.center,
                  params: {
                    'percent': activeCampaign.percent,
                  },
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              height: 194,
              width: 194,
              child: Image.network(activeCampaign.imageUrl!),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinkText("CAMPAIGN_SITE", onTap: () {
                InAppBrowser.openLink(
                  context,
                  activeCampaign.urlTos,
                  title: activeCampaign.name! + ' TOS',
                );
              }),
            ],
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
