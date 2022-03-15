import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CampaignHelper {
  static bool isActiveForState(UserState? userState, Campaign campaign) {
    return isActive(campaign, userState!.user, userState.account);
  }

  static bool isActive(Campaign campaign, User? user, Account? account) {
    var campaignStarted = campaign.isStarted();
    var isInCampaign = user!.hasCampaignAccount(campaign.code);
    var isCompany = account!.isCompany();

    return campaignStarted && !isInCampaign && !isCompany;
  }
}
