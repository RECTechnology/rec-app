// coverage:ignore-file

import 'package:rec/Pages/Private/Shared/campaigns/culture/culture-recharge-description.dart';
import 'package:rec/Pages/Private/Shared/campaigns/culture/extra-data-culture.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/culture/participate-culture.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/culture/welcome-culture.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/description-card-ltab.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/participate-ltab.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/welcome-ltab.page.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/providers/campaign-manager.dart';

List<CampaignDefinition> getCampaignDefinitions() {
  return [
    // LTAB20
    CampaignDefinition(
      code: env.CMP_LTAB_CODE,
      participateBuilder: (c, params) => LtabParticipatePage(
        hideDontShowAgain: params['hideDontShowAgain'] ?? false,
      ),
      welcomeBuilder: (c, p) => LtabWelcomePage(),
      canBeOpened: (c) => LtabParticipatePage.shouldBeOpenned(c),
      hasAcceptedTOS: (c) {
        return UserState.deaf(c).user!.privateTosLtab! &&
            UserState.deaf(c).user!.getAccountForCampaign(env.CMP_LTAB_CODE) != null;
      },
      rechargeDescriptionBuilder: (c, p) => LtabDescriptionCard(),
    ),
    // CULT21
    CampaignDefinition(
      code: env.CMP_CULT_CODE,
      participateBuilder: (c, params) => CultureParticipatePage(
        hideDontShowAgain: params['hideDontShowAgain'] ?? false,
      ),
      welcomeBuilder: (c, p) => CultureWelcomePage(),
      extraDataBuilder: (c, p) => CultureExtraDataPage(),
      canBeOpened: (c) => CultureParticipatePage.shouldBeOpenned(c),
      hasAcceptedTOS: (c) {
        return UserState.deaf(c).user!.privateTosCulture!;
      },
      rechargeDescriptionBuilder: (c, p) => CultureDescriptionCard(),
    ),
  ];
}
