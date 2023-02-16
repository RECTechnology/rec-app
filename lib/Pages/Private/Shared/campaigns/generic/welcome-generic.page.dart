import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:rec/Components/Icons/currency_icon.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LinkText.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/styled_text.dart';
import 'package:rec/Components/boxes.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/providers/account_campaign_provider.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class GenericWelcomePage extends StatefulWidget {
  final Campaign campaign;

  const GenericWelcomePage({
    Key? key,
    required this.campaign,
  }) : super(key: key);

  @override
  _GenericWelcomePageState createState() => _GenericWelcomePageState();
}

class _GenericWelcomePageState extends State<GenericWelcomePage> {
  Future<bool> _popBackHome() {
    Navigator.of(context).popUntil(ModalRoute.withName(Routes.home));
    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AccountCampaignProvider.deaf(context).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _popBackHome,
      child: Scaffold(
        appBar: EmptyAppBar(context, title: 'WELCOME_CAMPAIGN_TITLE'),
        backgroundColor: Colors.white,
        body: _body(),
      ),
    );
  }

  Widget _body() {
    final activeCampaign = widget.campaign;
    final hasPromoUrl = widget.campaign.promoUrl != null && widget.campaign.promoUrl!.isNotEmpty;
    final recTheme = RecTheme.of(context);
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LocalizedStyledText(
            'PART_OF_CAMPAIGN',
            style: theme.textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.w500,
              color: recTheme?.grayDark,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
            uppercase: true,
            params: {
              "campaign": widget.campaign.name,
            },
          ),
          const SizedBox(height: 32),
          LocalizedText(
            widget.campaign.bonusEnabled
                ? 'PART_OF_CAMPAIGN_DESC'
                : 'PART_OF_CAMPAIGN_NO_BONUS_DESC',
            style: theme.textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.w400,
              color: recTheme?.grayDark3,
              fontSize: 20,
            ),
            params: {
              'percent': activeCampaign.percent,
              'finish_date': DateFormat.yMMMd(localizations!.locale.languageCode)
                  .format(activeCampaign.endDate ?? DateTime.now()),
            },
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          LocalizedStyledText(
            'BONIFICATIONS',
            style: theme.textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.w500,
              color: recTheme?.primaryColor,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
            uppercase: true,
          ),
          const SizedBox(height: 16),
          _balanceCard(),
          if (hasPromoUrl) const SizedBox(height: 32),
          if (hasPromoUrl)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinkText(
                  'GOTO_CAMPAIGN_WEB',
                  onTap: () {
                    InAppBrowser.openLink(context, activeCampaign.promoUrl);
                  },
                ),
              ],
            ),
          const SizedBox(height: 32),
          RecActionButton(
            padding: Paddings.button.copyWith(top: 0),
            label: 'RECHARGE',
            onPressed: _next,
          ),
        ],
      ),
    );
  }

  _next() {
    Navigator.of(context).pushReplacementNamed(Routes.recharge);
  }

  _balanceCard() {
    final recTheme = RecTheme.of(context);
    final theme = Theme.of(context);
    final defaultTextStyle = theme.textTheme.subtitle1!.copyWith(
      fontWeight: FontWeight.w500,
      color: Colors.white,
      fontSize: 20,
    );
    final accountCampaignProvider = AccountCampaignProvider.of(context);
    final accountCampaign = AccountCampaignProvider.of(context).getForCampaign(
      widget.campaign,
    );
    final totalBalance =
        Currency.rec.scaleAmount(accountCampaignProvider.list?.totalAccumulatedBonus ?? 0);
    final accountBonus = Currency.rec.scaleAmount(accountCampaign?.acumulatedBonus ?? 0);
    final accountSpent = Currency.rec.scaleAmount(accountCampaign?.spentBonus ?? 0);
    final maxScaled = Currency.rec.scaleAmount(widget.campaign.max ?? 0);
    final accountAvailableBonus = accountBonus - accountSpent;

    return Column(
      children: [
        GradientBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: LocalizedStyledText(
                  'BONUS_IN_USER',
                  overflow: TextOverflow.ellipsis,
                  style: defaultTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        totalBalance.toStringAsFixed(2),
                        style: defaultTextStyle.copyWith(fontSize: 32),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          ' / ${maxScaled.toStringAsFixed(2)}',
                          style: defaultTextStyle.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  CurrencyIcon(size: 18),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LocalizedText(
          'DESC_BONUS_USER',
          params: {"max": maxScaled},
          textAlign: TextAlign.center,
          style: TextStyle(color: recTheme?.grayDark3, fontSize: 12),
        ),
        const SizedBox(height: 32),
        GradientBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: LocalizedStyledText(
                  'BONUS_IN_ACCOUNT',
                  overflow: TextOverflow.ellipsis,
                  style: defaultTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w300),
                  params: {
                    "account": accountCampaign?.account.name,
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accountAvailableBonus.toStringAsFixed(2),
                    style: defaultTextStyle.copyWith(fontSize: 32),
                  ),
                  const SizedBox(width: 8),
                  CurrencyIcon(size: 18),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LocalizedText(
          'DESC_BONUS_ACCOUNT',
          params: {"amount": accountAvailableBonus},
          textAlign: TextAlign.center,
          style: TextStyle(color: recTheme?.grayDark3, fontSize: 12),
        ),
      ],
    );
  }
}

class LabeledBalance extends StatelessWidget {
  final String label;

  const LabeledBalance({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LocalizedText(label),
      ],
    );
  }
}
