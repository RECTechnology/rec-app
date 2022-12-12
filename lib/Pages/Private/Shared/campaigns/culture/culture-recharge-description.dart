import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';

class CultureDescriptionCard extends StatelessWidget {
  CultureDescriptionCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recTheme = RecTheme.of(context);
    final campaignProvider = CampaignProvider.of(context);
    final userState = UserState.of(context);

    final cultureCampaign = campaignProvider.getCampaignByCode(env.CMP_CULT_CODE);
    final cultureAccount = userState.user!.getAccountForCampaign(env.CMP_CULT_CODE)!;

    final maxReached = cultureAccount.rewardedAmount! >= cultureCampaign!.max;
    final bonusEnded = cultureCampaign.isStarted() &&
        !cultureCampaign.isFinished() &&
        cultureCampaign.bonusEnabled == false;

    var title = maxReached ? 'CULTURE_RECHARGE_MODAL_MAX_TITLE' : 'CULTURE_RECHARGE_MODAL_TITLE';
    var descr = maxReached ? 'CULTURE_RECHARGE_MODAL_MAX_DESC' : 'CULTURE_RECHARGE_MODAL_DESC';
    var color = maxReached ? recTheme!.red : recTheme!.grayDark2;
    var bgColor = maxReached ? recTheme.red.withAlpha(10) : recTheme.backgroundBannerCulture;

    if (bonusEnded) {
      title = 'CULTURE_BONUS_ENDED_TITLE';
      descr = 'CULTURE_BONUS_ENDED_DESC';
      color = recTheme.red;
      bgColor = recTheme.red.withAlpha(10);
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 60),
                child: LocalizedText(
                  title,
                  style: theme.textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                  params: {
                    'percent': cultureCampaign?.percent,
                  },
                ),
              ),
              const SizedBox(height: 16),
              LocalizedText(
                descr,
                style: theme.textTheme.bodyText1!.copyWith(
                  height: 1.22,
                  fontWeight: FontWeight.w400,
                ),
                params: {
                  'spent': cultureAccount.rewardedAmount,
                  'max': cultureCampaign?.max,
                  'percent': cultureCampaign?.percent,
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            width: 48,
            height: 48,
            child: Image.network(cultureCampaign!.imageUrl!),
          ),
        ),
      ],
    );
  }
}
