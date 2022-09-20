import 'package:flutter/material.dart';
import 'package:rec/Components/Layout/campaign_participate_layout.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Private/Shared/campaigns/culture/info-box-culture.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/campaign_helper.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/preference_provider.dart';
import 'package:rec/providers/campaign_manager.dart';
import 'package:rec/providers/preferences/PreferenceDefinitions.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CultureParticipatePage extends StatefulWidget {
  final bool hideDontShowAgain;

  CultureParticipatePage({
    Key? key,
    this.hideDontShowAgain = false,
  }) : super(key: key);

  @override
  _CultureParticipatePageState createState() => _CultureParticipatePageState();

  static String code = env.CMP_CULT_CODE;

  static bool isActive(BuildContext context) {
    return CampaignProvider.deaf(context).isActive(code);
  }

  static bool shouldBeOpenned(BuildContext context) {
    final preferences = PreferenceProvider.deaf(context);
    final showBanner = preferences.get(PreferenceKeys.showCultureCampaign);
    final userState = UserState.deaf(context);
    final activeCampaign = CampaignProvider.deaf(context).getCampaignByCode(code);

    final active = isActive(context);
    final isActiveForState = CampaignHelper.isActiveForState(userState, activeCampaign!);
    final shouldBeOpened = active && showBanner && isActiveForState;

    return shouldBeOpened;
  }
}

class _CultureParticipatePageState extends State<CultureParticipatePage> {
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
    final preferences = PreferenceProvider.of(context);
    final dontShowAgain = preferences.get(PreferenceKeys.showCultureCampaign);
    final assets = RecTheme.of(context)!.assets;

    return CampaignParticipateLayout(
      campaignCode: CultureParticipatePage.code,
      dontShowAgain: dontShowAgain,
      dontShowAgainChanged: _dontShowAgainChanged,
      hideDontShowAgain: termsAccepted || widget.hideDontShowAgain,
      onClose: _close,
      onParticipate: termsAccepted ? _participate : null,
      image: AssetImage(assets.cultureCampaignBanner),
      infoChild: CultureInfoBox(
        termsAccepted: termsAccepted,
        termsAcceptedChanged: (value) {
          setState(() {
            termsAccepted = value!;
            _dontShowAgainChanged(false);
          });
        },
      ),
      buttonLabel: userState!.user!.hasExtraData ? 'PARTICIPATE' : 'NEXT',
    );
  }

  void _dontShowAgainChanged(bool? value) async {
    await PreferenceProvider.deaf(context).set(
      PreferenceKeys.showCultureCampaign,
      !value!,
    );
  }

  void _close() {
    Navigator.of(context).pop();
  }

  void _participate() async {
    var definition = campaignManager!.getDefinition(CultureParticipatePage.code);
    var hasExtraDataBuilder = Checks.isNotNull(definition!.extraDataBuilder);
    var userState = UserState.of(context, listen: false);
    // var isKyc2 = userState.user!.anyAccountAtLevel(Level.CODE_KYC2);
    // Removed kyc check because diego told me to

    if (!user!.hasExtraData && hasExtraDataBuilder) {
      var result = await RecNavigation.navigate(
        context,
        (c) => definition.extraDataBuilder!(context, {}),
      );

      // We should not continue forwards if user does not fill in data
      if (result == null) return;
    }

    try {
      await Loading.show();
      await userState.userService.acceptCampaignTos(CultureParticipatePage.code);
      await userState.getUser();
      await Loading.dismiss();

      await RecNavigation.replace(
        context,
        (c) => definition.welcomeBuilder(context, {}),
      );
    } catch (err) {
      RecToast.showError(
        context,
        err.toString(),
      );
    }
  }
}
