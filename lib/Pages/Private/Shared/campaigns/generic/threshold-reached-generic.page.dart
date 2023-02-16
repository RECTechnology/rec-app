import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LinkText.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/rec_preferences.dart';
import 'package:rec/providers/All.dart';
import 'package:rec/providers/account_campaign_provider.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class GenericThresholdReachedPage extends StatefulWidget {
  final Campaign campaign;
  const GenericThresholdReachedPage({
    Key? key,
    required this.campaign,
  }) : super(key: key);

  @override
  _GenericThresholdReachedPageState createState() => _GenericThresholdReachedPageState();

  static bool isActive(BuildContext context, Campaign campaign) {
    return campaign.status == Campaign.STATUS_ACTIVE;
  }

  static bool thresholdReachedShouldBeOpened(BuildContext context, Campaign campaign) {
    final accountCampaignProvider = AccountCampaignProvider.deaf(context);

    // User has not marked "don't show again"
    final dontShowAgain =
        RecPreferences.get(PreferenceKeys.showGenericThresholdReached + '${campaign.id}');

    if (dontShowAgain == true) return false;

    // User is in campaign
    final hasCampaignAccount = accountCampaignProvider.getForCampaign(campaign) != null;
    if (!hasCampaignAccount) return false;

    // Campaign is active
    if (!isActive(context, campaign)) return false;

    // Bonus is enabled for the campaign
    if (campaign.bonusEnabled == false) return false;

    // In all other cases we can show the threshold reached page
    return campaign.endingAlert == true;
  }
}

class _GenericThresholdReachedPageState extends State<GenericThresholdReachedPage> {
  bool dontShowAgain = false;

  @override
  void initState() {
    super.initState();
    dontShowAgain =
        RecPreferences.get(PreferenceKeys.showGenericThresholdReached + '${widget.campaign.id}') ==
            true;
  }

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
    final localizations = AppLocalizations.of(context);
    final assets = recTheme!.assets;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(32, 24, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (widget.campaign.imageUrl != null && widget.campaign.imageUrl!.isNotEmpty)
                  Opacity(
                    opacity: 0.1,
                    child: Image.network(
                      widget.campaign.imageUrl!,
                      height: 160,
                    ),
                  ),
                if (widget.campaign.imageUrl == null || widget.campaign.imageUrl!.isEmpty)
                  Opacity(
                    opacity: 0.1,
                    child: Image.asset(
                      assets.logo,
                      height: 160,
                    ),
                  ),
                Center(child: Icon(Icons.warning, color: Colors.red, size: 80)),
              ],
            ),
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
              params: {
                'finish_date': DateFormat.yMMMd(localizations!.locale.languageCode)
                    .format(widget.campaign.endDate ?? DateTime.now()),
              },
            ),
            const SizedBox(height: 32),
            if (widget.campaign.promoUrl?.isNotEmpty == true)
              LinkText(
                'GOTO_CAMPAIGN_WEB',
                onTap: () {
                  InAppBrowser.openLink(context, widget.campaign.promoUrl);
                },
                alignment: Alignment.center,
              ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: dontShowAgain,
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
    _dontShowAgainChanged(dontShowAgain);
    Navigator.of(context).pop();
  }

  void _dontShowAgainChanged(bool? value) async {
    dontShowAgain = value ?? false;
    setState(() {});
    RecPreferences.setBool(
      PreferenceKeys.showGenericThresholdReached + '${widget.campaign.id}',
      dontShowAgain,
    );
  }
}
