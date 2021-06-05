import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Entities/Campaign.ent.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Providers/CampaignProvider.dart';
import 'package:rec/Providers/PreferenceProvider.dart';
import 'package:rec/Providers/Preferences/PreferenceDefinitions.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LtabInitialBanner extends StatefulWidget {
  final Campaign campaign;

  LtabInitialBanner(
    this.campaign, {
    Key key,
  }) : super(key: key);

  @override
  _LtabInitialBannerState createState() => _LtabInitialBannerState();

  static bool shouldBeOpenned(BuildContext context) {
    var preferences = PreferenceProvider.of(context, listen: false);
    var campaignProvider = CampaignProvider.of(context, listen: false);
    var userState = UserState.of(context, listen: false);

    var showBanner = preferences.get(PreferenceKeys.showLtabCampaign);
    var activeCampaign = campaignProvider.activeCampaign;
    var noActiveCampaign = Checks.isNull(activeCampaign);

    // If there is no active campaign, it's most definitely should not be opened
    if (noActiveCampaign) return false;

    var campaignActive = activeCampaign.isActiveForState(userState);

    return campaignActive && showBanner && campaignActive;
  }
}

class _LtabInitialBannerState extends State<LtabInitialBanner> {
  bool _dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: EmptyAppBar(
        context,
        backArrow: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Brand.grayDark),
            onPressed: _close,
          ),
        ],
      ),
      body: Stack(children: [
        Image.asset(
          'assets/banner-bg.jpg',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.white.withAlpha(180),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 100,
            bottom: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LocalizedText(
                'LTAB_INITIAL_BANNER_TITLE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Brand.grayDark,
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
              ),
              const SizedBox(height: 24),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: widget.campaign.videoPromoUrl,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _dontShowAgain,
                    onChanged: onChanged,
                  ),
                  LocalizedText('DONT_SHOW_AGAIN'),
                ],
              ),
              const SizedBox(height: 24),
              RecActionButton(
                label: _dontShowAgain ? 'CLOSE' : 'PARTICIPATE',
                onPressed: _dontShowAgain ? _close : _participate,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void onChanged(bool value) {
    setState(() {
      _dontShowAgain = value;
    });
  }

  void _close() {
    if (_dontShowAgain) {
      PreferenceProvider.deaf(context).set(
        PreferenceKeys.showLtabCampaign,
        false,
      );
    }

    Navigator.of(context).pop();
  }

  void _participate() {
    Navigator.pushReplacementNamed(context, Routes.recharge);
  }
}
