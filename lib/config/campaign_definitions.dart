// coverage:ignore-file

import 'package:rec/Pages/Private/Shared/campaigns/culture/culture-recharge-description.dart';
import 'package:rec/Pages/Private/Shared/campaigns/culture/extra-data-culture.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/culture/participate-culture.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/culture/threshold-reached.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/culture/welcome-culture.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/generic/generic-recharge-description.dart';
import 'package:rec/Pages/Private/Shared/campaigns/generic/participate-generic.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/generic/threshold-reached-generic.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/generic/welcome-generic.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/description-card-ltab.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/participate-ltab.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/welcome-ltab.page.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/account_campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/providers/campaign_manager.dart';

List<CampaignDefinition> getCampaignDefinitions() {
  return [
    // LTAB20
    CampaignDefinition(
      code: env.CMP_LTAB_CODE,
      participateBuilder: (c, params, __) => LtabParticipatePage(
        hideDontShowAgain: params['hideDontShowAgain'] ?? false,
      ),
      welcomeBuilder: (_, __, ___) => LtabWelcomePage(),
      canBeOpened: (c, __) => LtabParticipatePage.shouldBeOpenned(c),
      hasAcceptedTOS: (c, __) {
        return UserState.deaf(c).user!.privateTosLtab! &&
            UserState.deaf(c).user!.getAccountForCampaign(env.CMP_LTAB_CODE) != null;
      },
      rechargeDescriptionBuilder: (_, __, ___) => LtabDescriptionCard(),
      thresholdReachedBuilder: (_, __, ___) {},
      thresholdReachedCanBeOpened: (_, __) => true,
    ),
    // CULT21
    CampaignDefinition(
      code: env.CMP_CULT_CODE,
      participateBuilder: (c, params, ___) => CultureParticipatePage(
        hideDontShowAgain: params['hideDontShowAgain'] ?? false,
      ),
      welcomeBuilder: (_, __, ___) => CultureWelcomePage(),
      extraDataBuilder: (_, __, ___) => CultureExtraDataPage(),
      canBeOpened: (c, __) => CultureParticipatePage.shouldBeOpenned(c),
      hasAcceptedTOS: (c, __) {
        return UserState.deaf(c).user!.privateTosCulture!;
      },
      rechargeDescriptionBuilder: (_, __, ___) => CultureDescriptionCard(),
      thresholdReachedBuilder: (_, __, ___) => ThresholdReachedPage(),
      thresholdReachedCanBeOpened: (c, __) =>
          ThresholdReachedPage.thresholdReachedShouldBeOpened(c),
    ),
    CampaignDefinition(
      code: 'generic',
      participateBuilder: (c, params, campaign) => GenericCampaignParticipatePage(
        hideDontShowAgain: params['hideDontShowAgain'] ?? false,
        campaign: campaign,
      ),
      welcomeBuilder: (_, __, campaign) => GenericWelcomePage(campaign: campaign),
      canBeOpened: (c, campaign) => GenericCampaignParticipatePage.shouldBeOpenned(c, campaign),
      hasAcceptedTOS: (c, campaign) {
        final provider = AccountCampaignProvider.deaf(c);
        final accountCampaign = provider.getForCampaign(campaign);
        return accountCampaign != null;
      },
      rechargeDescriptionBuilder: (_, __, campaign) => GenericDescriptionCard(),
      thresholdReachedBuilder: (_, __, campaign) => GenericThresholdReachedPage(campaign: campaign),
      thresholdReachedCanBeOpened: (c, campaign) =>
          GenericThresholdReachedPage.thresholdReachedShouldBeOpened(c, campaign),
    ),
  ];
}
