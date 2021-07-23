import 'package:flutter/material.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/Inputs/AmountTextField.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/Entities/Campaign.ent.dart';
import 'package:rec/Entities/Forms/RechargeData.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecNavigation.dart';
import 'package:rec/Pages/LtabCampaign/CampaignDescriptionCard.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/AttemptRecharge.dart';
import 'package:rec/Pages/Private/Shared/RequestPin.page.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/CampaignProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class RechargePage extends StatefulWidget {
  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  final _formKey = GlobalKey<FormState>();
  final _usersService = UsersService();

  RechargeData rechargeData = RechargeData();

  Campaign activeCampaign;

  @override
  void didChangeDependencies() {
    activeCampaign ??= CampaignProvider.of(
      context,
      listen: false,
    ).activeCampaign;

    super.didChangeDependencies();
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
    var localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Container(
        padding: Paddings.page,
        child: Column(
          children: [
            Text(
              localizations.translate('RECHARGE_DESC'),
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
                    validator: _customAmountValidator,
                  ),
                  SizedBox(height: 32),
                  CampaignDescriptionCard(
                    termsAccepted: rechargeData.campaignTermsAccepted,
                    termsAcceptedChanged: (accepted) {
                      setState(
                        () => rechargeData.campaignTermsAccepted = accepted,
                      );
                    },
                  ),
                  SizedBox(height: 25),
                  RecActionButton(
                    label: localizations.translate('RECHARGE'),
                    icon: Icons.arrow_forward_ios_sharp,
                    onPressed: _forwards,
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
    var newAmount =
        double.parse(value.isEmpty ? '0' : value.replaceAll(',', '.'));
    setState(() {
      rechargeData.amount = newAmount;
    });
  }

  String _customAmountValidator(String value) {
    var userState = UserState.of(context, listen: false);
    var localizations = AppLocalizations.of(context);
    var activeCampaign = CampaignProvider.of(
      context,
      listen: false,
    ).activeCampaign;

    var campaignActive = activeCampaign.isActiveForState(userState);
    var valueDouble = double.parse(value.isEmpty ? '0' : value);
    var reachesMin = valueDouble >= activeCampaign.min;
    if (valueDouble < 0.5) {
      return localizations.translate('MIN_RECHARGE');
    }
    if (campaignActive && !reachesMin && rechargeData.campaignTermsAccepted) {
      return localizations.translate(
        'CAMPAIGN_NOT_REACH_MIN',
        params: {
          'min': activeCampaign.min,
        },
      );
    }

    return null;
  }

  void _forwards() {
    if (!_formKey.currentState.validate()) return;

    Loading.show();
    _updateTos();

    rechargeData.willEnterCampaign = rechargeData.campaignTermsAccepted &&
        rechargeData.amount >= activeCampaign.min;

    Loading.dismiss();
    _requestPin();
  }

  void _requestPin() {
    RecNavigation.of(context).navigate(
      (_) => RequestPin(
        ifPin: _attemptRecharge,
      ),
    );
  }

  void _attemptRecharge(String pin) {
    RecNavigation.of(context).navigate(
      (_) => AttemptRecharge(
        data: rechargeData..pin = pin,
      ),
    );
  }

  // HACK: quickly added this here, needs improvement
  Future<Map<String, dynamic>> _updateTos() {
    var userState = UserState.of(context, listen: false);
    return _usersService.updateUser({
      'private_tos_campaign': rechargeData.campaignTermsAccepted,
    }).then((res) {
      userState.setUser(
        userState.user..privateTosCampaign = rechargeData.campaignTermsAccepted,
      );
      return res;
    });
  }
}
