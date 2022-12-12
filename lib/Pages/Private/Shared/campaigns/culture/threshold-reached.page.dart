import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/All.dart';
import 'package:rec/styles/paddings.dart';

class ThresholdReachedPage extends StatefulWidget {
  const ThresholdReachedPage({
    Key? key,
  }) : super(key: key);

  @override
  _ThresholdReachedPageState createState() => _ThresholdReachedPageState();

  static String code = env.CMP_CULT_CODE;
  static bool isActive(BuildContext context) {
    return CampaignProvider.deaf(context).isActive(code);
  }

  static bool thresholdReachedShouldBeOpened(BuildContext context) {
    final preferences = PreferenceProvider.deaf(context);
    final cultureCampaign = CampaignProvider.deaf(context).getCampaignByCode(code);
    final userState = UserState.deaf(context);


    // User has not marked "don't show again"
    final canShow = preferences.get(PreferenceKeys.showCultureThresholdReached);
    if (!canShow) return false;

    // User has a PRIVATE REC Cultural account
    final hasCampaignAccount = userState.user!.hasCampaignAccount(code);
    if (!hasCampaignAccount) return false;

    // Campaign is active
    if (!isActive(context)) return false;

    // Bonus is enabled for the campaign
    if (cultureCampaign?.bonusEnabled == false) return false;

    // In all other cases we can show the threshold reached page
    return cultureCampaign?.endingAlert == true;
  }
}

class _ThresholdReachedPageState extends State<ThresholdReachedPage> {
  Future<bool> _popBackHome() {
    Navigator.of(context).popUntil(ModalRoute.withName(Routes.home));
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _popBackHome,
      child: Scaffold(
        appBar: EmptyAppBar(context, backArrow: false),
        backgroundColor: Colors.white,
        body: _body(),
      ),
    );
  }

  Widget _body() {
    final recTheme = RecTheme.of(context);
    final assets = recTheme!.assets;
    final preferences = PreferenceProvider.of(context);
    final dontShowAgain = preferences.get(PreferenceKeys.showCultureThresholdReached);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(32, 24, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(assets.showCultureThresholdReached),
            const SizedBox(height: 32),
            LocalizedText(
              'CAMPAIGN_THRESHOLD_REACHED',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
            LocalizedText(
              'CAMPAIGN_THRESHOLD_REACHED_DESC',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: recTheme.grayLight,
              ),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: !(dontShowAgain ?? true),
                  onChanged: _dontShowAgainChanged,
                ),
                LocalizedText('DONT_SHOW_AGAIN'),
              ],
            ),
            const SizedBox(height: 18),
            RecActionButton(
              padding: Paddings.button.copyWith(top: 0),
              label: 'UNDERSTOOD',
              onPressed: _close,
            ),
          ],
        ),
      ),
    );
  }

  void _close() {
    Navigator.of(context).pop();
  }

  void _dontShowAgainChanged(bool? value) async {
    await PreferenceProvider.deaf(context).set(
      PreferenceKeys.showCultureThresholdReached,
      !value!,
    );
  }
}
