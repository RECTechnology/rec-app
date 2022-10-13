import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rec/Components/Inputs/text_fields/AmountTextField.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Wallet/user_balance.dart';
import 'package:rec/Pages/Private/Shared/RequestPin.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/ltab-stop-bonification.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/campaign_helper.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/attempt_recharge.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/description-card-ltab.page.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/providers/campaign_manager.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

import 'select_card.page.dart';

/// This page asks the user for recharge data and handles flow for a recharge
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
    SchedulerBinding.instance.addPostFrameCallback((_) => _checkLtabBonificatonStop());
  }

  void _checkLtabBonificatonStop() {
    final ltabCampaign = CampaignProvider.deaf(context).getCampaignByCode(env.CMP_LTAB_CODE);
    final isInCampaign = UserState.deaf(context).user!.hasCampaignAccount(env.CMP_LTAB_CODE);

    if (ltabCampaign == null) return;
    if (ltabCampaign.bonusEnabled) return;
    if (ltabCampaign.isFinished()) return;
    if (!isInCampaign) return;

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
            currencyIcon: Icon(Icons.euro, color: Colors.white),
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    final account = userState!.account;
    final isCultureAccount = account!.isCampaignAccount(env.CMP_CULT_CODE);
    final recTheme = RecTheme.of(context);

    return SingleChildScrollView(
      child: Container(
        padding: Paddings.page,
        child: Column(
          children: [
            LocalizedText(
              'RECHARGE_DESC',
              style: TextStyle(
                fontSize: 13,
                color: recTheme!.grayDark2,
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
                    icon: Icon(Icons.euro),
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
    final newAmount = double.parse(
      value.isEmpty ? '0' : value.replaceAll(',', '.'),
    );

    setState(() {
      rechargeData.amount = newAmount;
    });
  }

  String? _customAmountValidator(String? value) {
    final isCultureAccount = userState!.account!.isCampaignAccount(env.CMP_CULT_CODE);
    if (isCultureAccount) return null;

    final localizations = AppLocalizations.of(context);
    final campaignActive = CampaignHelper.isActiveForState(userState, ltabCampaign!);
    final valueDouble = double.parse(value!.isEmpty ? '0' : value);
    final reachesMin = valueDouble >= ltabCampaign!.min;

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

    final ltabCampaign = CampaignProvider.deaf(context).getCampaignByCode(env.CMP_LTAB_CODE);
    final alreadyHasLtabAccount = userState!.user!.hasCampaignAccount(env.CMP_LTAB_CODE);
    final isCultureAccount = userState!.account!.isCampaignAccount(env.CMP_CULT_CODE);
    final ltabCampaignActive = CampaignHelper.isActiveForState(userState, ltabCampaign!);

    // Only update if not already set
    if (ltabCampaignActive &&
        userState?.user?.privateTosLtab != rechargeData.campaignTermsAccepted) {
      await _updateTos();
    }

    rechargeData.willEnterCampaign = ltabCampaignActive &&
        rechargeData.campaignTermsAccepted &&
        rechargeData.amount >= ltabCampaign.min &&
        !alreadyHasLtabAccount &&
        !isCultureAccount &&
        !ltabCampaign.bonusEnabled;

    Loading.dismiss();
    _requestPin();
  }

  _requestPin() {
    final userState = UserState.of(context, listen: false);

    // If user already has pin, we can proceed to attempt the recharge
    // this is done so user does not need to enter the pin if he already has it
    if (userState.user!.hasPin!) {
      return _goToSelectCard();
    }

    // If user has no pin, we need him to create a pin before attempting the recharge
    RecNavigation.of(context).navigate(
      (_) => RequestPin(
        ifPin: (__) => _goToSelectCard(),
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

  _goToSelectCard() async {
    final result = await RecNavigation.of(context).navigate(
      (_) => SelectCardPage(rechargeData: rechargeData),
    );

    // If value is null, it means that [SelectCardPage] has popped without selecting an action
    // so we just ignore it, they can press "Recharge" button again
    if (result == null) return;

    // If result is a [BankCard], it means that the user has selected a saved card
    if (result is BankCard) {
      rechargeData.cardId = result.id;
    }

    // Otherwise if it's a bool (true for save card, false for not save card)
    // set [saveCard] to the result, as to tell the recharge if the user wants to save the card or not
    if (result is bool) {
      rechargeData.saveCard = result;
    }

    return _attemptRecharge();
  }

  _updateTos() async {
    await userState!.userService.updateLtabTos(rechargeData.campaignTermsAccepted);
    await userState!.getUser();
  }
}
