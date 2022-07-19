import 'package:flutter/material.dart';
import 'package:rec/Components/Layout/campaign_participate_layout.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/info-box-ltab.dart';
import 'package:rec/config/assets.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/campaign_helper.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/preference_provider.dart';
import 'package:rec/providers/campaign_manager.dart';
import 'package:rec/providers/preferences/PreferenceDefinitions.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class LtabParticipatePage extends StatefulWidget {
  final bool hideDontShowAgain;

  LtabParticipatePage({
    Key? key,
    this.hideDontShowAgain = false,
  }) : super(key: key);

  static String code = env.CMP_LTAB_CODE;

  @override
  _LtabParticipatePageState createState() => _LtabParticipatePageState();

  static bool isActive(BuildContext context) {
    return CampaignProvider.deaf(context).isActive(LtabParticipatePage.code);
  }

  static bool shouldBeOpenned(BuildContext context) {
    var preferences = PreferenceProvider.deaf(context);
    var showBanner = preferences.get(PreferenceKeys.showLtabCampaign) ?? false;
    var userState = UserState.deaf(context);
    var activeCampaign = CampaignProvider.deaf(context).getCampaignByCode(
      LtabParticipatePage.code,
    );

    return isActive(context) &&
        showBanner &&
        CampaignHelper.isActiveForState(userState, activeCampaign!);
  }
}

class _LtabParticipatePageState extends State<LtabParticipatePage> {
  UserState? userState;
  CampaignManager? campaignManager;
  bool termsAccepted = false;

  User? get user => userState!.user;

  @override
  void didChangeDependencies() {
    userState ??= UserState.of(context);
    campaignManager ??= CampaignManager.of(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var preferences = PreferenceProvider.of(context);
    var dontShowAgain = preferences.get(PreferenceKeys.showLtabCampaign);

    return CampaignParticipateLayout(
      campaignCode: LtabParticipatePage.code,
      dontShowAgain: dontShowAgain,
      dontShowAgainChanged: _dontShowAgainChanged,
      hideDontShowAgain: widget.hideDontShowAgain,
      onClose: _close,
      onParticipate: _participate,
      image: AssetImage(Assets.ltabCampaignBanner),
      infoChild: LtabInfoBox(
        termsAccepted: termsAccepted,
        termsAcceptedChanged: (value) {
          setState(() => termsAccepted = value!);
        },
      ),
      buttonLabel: 'NEXT',
    );
  }

  void _dontShowAgainChanged(bool? value) async {
    await PreferenceProvider.deaf(context).set(
      PreferenceKeys.showLtabCampaign,
      !value!,
    );
  }

  void _close() {
    Navigator.of(context).pop();
  }

  void _participate() async {
    var definition = campaignManager!.getDefinition(LtabParticipatePage.code);
    var hasExtraDataBuilder = Checks.isNotNull(definition!.extraDataBuilder);

    if (!user!.hasExtraData && hasExtraDataBuilder) {
      var result = await RecNavigation.navigate(
        context,
        (c) => definition.extraDataBuilder!(context, {}),
      );

      // We should not continue forwards if user does not fill in data
      if (result == null) return;
    }

    try {
      await Navigator.of(context).pushReplacementNamed(Routes.recharge);
    } catch (err) {
      RecToast.showError(
        context,
        err.toString(),
      );
    }
  }
}
