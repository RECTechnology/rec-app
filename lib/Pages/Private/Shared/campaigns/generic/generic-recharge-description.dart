import 'package:flutter/material.dart';
import 'package:rec/Components/boxes.dart';
import 'package:rec/Components/Text/LinkText.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/styled_text.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/providers/account_campaign_provider.dart';
import 'package:rec/providers/campaign_manager.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class GenericDescriptionCard extends StatelessWidget {
  GenericDescriptionCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final campaignProvider = CampaignProvider.of(context);
    final accountCampaigns = AccountCampaignProvider.of(context);
    final account = UserState.of(context).account;

    // If there is no active campaign, no need to show anything
    final v2Campaign = campaignProvider.firstActiveV2();
    if (v2Campaign == null) return SizedBox.shrink();

    final campaignActive = v2Campaign.status == Campaign.STATUS_ACTIVE;
    final accCampaign = accountCampaigns.getForCampaign(v2Campaign);

    // User not in campaign, show enter campaign descr
    final notInCampaign =
        accCampaign == null && campaignActive && v2Campaign.bonusEnabled && account!.isPrivate();
    if (notInCampaign) {
      return _enterCampaign(context, v2Campaign);
    }

    // User not in campaign, show enter campaign descr
    final maxReached = accCampaign != null &&
        (accountCampaigns.list?.totalAccumulatedBonus ?? 0) >= v2Campaign.max &&
        campaignActive &&
        v2Campaign.bonusEnabled;
    if (maxReached && accCampaign != null) {
      return _limitReached(context, v2Campaign, accCampaign);
    }

    // IF user is in campaign and max has not been reached
    if (campaignActive && v2Campaign.bonusEnabled && accCampaign != null) {
      return _campaignInfo(context, v2Campaign, accCampaign);
    }

    return SizedBox.shrink();
  }

  Widget _enterCampaign(BuildContext context, Campaign campaign) {
    final theme = Theme.of(context);
    final recTheme = RecTheme.of(context);
    final genericDefinition = CampaignManager.deaf(context).getDefinition('generic');

    return GrayBox(
      width: double.infinity,
      height: null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocalizedText(
            'ENTER_CAMPAIGN_BOX_TITLE',
            style: theme.textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.w500,
              color: recTheme!.grayDark2,
              fontSize: 18,
            ),
            params: {"percent": campaign.percent},
          ),
          const SizedBox(height: 12),
          LocalizedStyledText(
            'ENTER_CAMPAIGN_BOX_DESC',
            style: theme.textTheme.caption!.copyWith(fontSize: 14),
            params: {"percent": campaign.percent, "campaign": campaign.name},
          ),
          LinkText(
            'Participar',
            onTap: () {
              RecNavigation.of(context).navigate(
                (_) => genericDefinition!.participateBuilder(context, {}, campaign),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _limitReached(BuildContext context, Campaign campaign, AccountCampaign accCampaign) {
    final recTheme = RecTheme.of(context);
    final theme = Theme.of(context);

    return GrayBox(
      background: recTheme!.red.withAlpha(10),
      height: null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: recTheme.red),
              const SizedBox(width: 8),
              Flexible(
                child: LocalizedText(
                  'CAMPAIGN_BONUS_REACHED',
                  style: theme.textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: recTheme.red,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LocalizedText(
            'CAMPAIGN_BONUS_REACHED_DESC',
            style: theme.textTheme.caption!.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _campaignInfo(BuildContext context, Campaign campaign, AccountCampaign accCampaign) {
    final theme = Theme.of(context);
    final recTheme = RecTheme.of(context);
    final accountCampaignProvider = AccountCampaignProvider.of(context);
    final maxedScaled = Currency.rec.scaleAmount(campaign.max);
    final accumulated =
        Currency.rec.scaleAmount(accountCampaignProvider.list?.totalAccumulatedBonus ?? 0);

    return GrayBox(
      width: double.infinity,
      height: null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      background: recTheme?.backgroundPrivateColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                child: campaign.imageUrl == null || campaign.imageUrl!.isEmpty
                    ? Image.asset(recTheme!.assets.logo)
                    : Image.network(campaign.imageUrl!),
              ),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                child: LocalizedStyledText(
                  'INFO_CAMPAIGN_BOX_TITLE',
                  style: theme.textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: recTheme!.grayDark2,
                    fontSize: 18,
                  ),
                  params: {
                    'percent': campaign.percent,
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LocalizedStyledText(
            'INFO_CAMPAIGN_BOX_DESC',
            style: theme.textTheme.caption!.copyWith(fontSize: 14),
            params: {
              'remaining': (maxedScaled - accumulated).toStringAsFixed(2),
              'bonus': accumulated.toStringAsFixed(2),
              'max': maxedScaled,
            },
          ),
        ],
      ),
    );
  }
}
