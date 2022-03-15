import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rec/Components/Inputs/text_fields/AmountTextField.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/Pages/Private/Shared/RequestPin.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/ltab-stop-bonification.dart';
import 'package:rec/helpers/campaign_helper.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/AttemptRecharge.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/description-card-ltab.page.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/providers/campaign-manager.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RechargePage extends StatefulWidget {
  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  final _formKey = GlobalKey<FormState>();

  CampaignManager? campaignManager;
  CampaignProvider? campaignProvider;
  UserState? userState;

  RechargeData rechargeData = RechargeData();
  CampaignDefinition? cultureDefinition;
  CampaignDefinition? ltabDefinition;
  Campaign? ltabCampaign;
  Campaign? cultCampaign;

  @override
  void didChangeDependencies() {
    campaignManager ??= CampaignManager.of(context);
    campaignProvider ??= CampaignProvider.of(context);
    userState ??= UserState.of(context);
    cultureDefinition ??= campaignManager!.getDefinition(env.CMP_CULT_CODE);
    cultCampaign ??= campaignProvider!.getCampaignByCode(env.CMP_CULT_CODE);

    ltabDefinition ??= campaignManager!.getDefinition(env.CMP_LTAB_CODE);
    ltabCampaign ??= campaignProvider!.getCampaignByCode(env.CMP_LTAB_CODE);

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) => _checkLtabBonificatonStop());
  }

  void _checkLtabBonificatonStop() {
    var ltabCampaign = CampaignProvider.deaf(context).getCampaignByCode(env.CMP_LTAB_CODE);
    var isInCampaign = UserState.deaf(context).user!.hasCampaignAccount(env.CMP_LTAB_CODE);

    if (ltabCampaign != null &&
        !ltabCampaign.bonusEnabled &&
        !ltabCampaign.isFinished() &&
        isInCampaign) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: LtabBonificacionStop(),
          ),
        ),
      ).then((value) => print('done ' + value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrivateAppBar(
        hasBackArrow: true,
        selectAccountEnabled: false,
        size: 160,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: UserBalance(
            balance: rechargeData.amount,
            label: 'TOTAL_RECHARGE',
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    var account = userState!.account;
    var isCultureAccount = account!.isCampaignAccount(env.CMP_CULT_CODE);

    return SingleChildScrollView(
      child: Container(
        padding: Paddings.page,
        child: Column(
          children: [
            LocalizedText(
              'RECHARGE_DESC',
              style: TextStyle(
                fontSize: 13,
                color: Brand.grayDark2,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  AmountTextField(
                    onChange: _amountChanged,
                    onSubmitted: (s) => _forwards(),
                    validator: _customAmountValidator,
                  ),
                  SizedBox(height: 32),
                  if (isCultureAccount) cultureDefinition!.rechargeDescriptionBuilder(context, {}),
                  if (!isCultureAccount)
                    LtabDescriptionCard(
                      termsAccepted: rechargeData.campaignTermsAccepted,
                      termsAcceptedChanged: (accepted) {
                        setState(
                          () => rechargeData.campaignTermsAccepted = accepted!,
                        );
                      },
                    ),
                  SizedBox(height: 25),
                  RecActionButton(
                    label: 'RECHARGE',
                    icon: Icons.arrow_forward_ios_sharp,
                    onPressed: rechargeData.amount > 0 ? _forwards : null,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _amountChanged(value) {
    var newAmount = double.parse(
      value.isEmpty ? '0' : value.replaceAll(',', '.'),
    );

    setState(() {
      rechargeData.amount = newAmount;
    });
  }

  String? _customAmountValidator(String? value) {
    var isCultureAccount = userState!.account!.isCampaignAccount(env.CMP_CULT_CODE);
    if (isCultureAccount) return null;

    var localizations = AppLocalizations.of(context);
    var campaignActive = CampaignHelper.isActiveForState(userState, ltabCampaign!);
    var valueDouble = double.parse(value!.isEmpty ? '0' : value);
    var reachesMin = valueDouble >= ltabCampaign!.min;

    if (valueDouble < 0.5) {
      return localizations!.translate('MIN_RECHARGE');
    }

    if (campaignActive && !reachesMin && rechargeData.campaignTermsAccepted) {
      return localizations!.translate(
        'CAMPAIGN_NOT_REACH_MIN',
        params: {
          'min': ltabCampaign!.min,
        },
      );
    }

    return null;
  }

  void _forwards() async {
    if (!_formKey.currentState!.validate()) return;

    Loading.show();

    var ltabCampaign = CampaignProvider.deaf(context).getCampaignByCode(env.CMP_LTAB_CODE);
    var alreadyHasLtabAccount = userState!.user!.hasCampaignAccount(env.CMP_LTAB_CODE);
    var isCultureAccount = userState!.account!.isCampaignAccount(env.CMP_CULT_CODE);

    // Only update if not already set
    await _updateTos();

    rechargeData.willEnterCampaign = rechargeData.campaignTermsAccepted &&
        rechargeData.amount >= ltabCampaign!.min &&
        !alreadyHasLtabAccount &&
        !isCultureAccount &&
        !ltabCampaign.bonusEnabled;

    Loading.dismiss();
    _requestPin();
  }

  void _requestPin() {
    var userState = UserState.of(context, listen: false);

    // If user already has pin, we can proceed to attempt the recharge
    // this is done so user does not need to enter the pin if he already has it
    if (userState.user!.hasPin!) {
      return _attemptRecharge();
    }

    // If user has no pin, we need him to create a pin before attempting the recharge
    RecNavigation.of(context).navigate(
      (_) => RequestPin(
        ifPin: (__) => _attemptRecharge(),
      ),
    );
  }

  void _attemptRecharge() {
    RecNavigation.of(context).navigate(
      (_) => AttemptRecharge(
        data: rechargeData,
      ),
    );
  }

  _updateTos() async {
    await userState!.userService.updateLtabTos(rechargeData.campaignTermsAccepted);
    await userState!.getUser();
  }
}
