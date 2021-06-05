import 'package:flutter/material.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/Inputs/AmountTextField.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/User/UserBalance.dart';
import 'package:rec/Entities/Forms/RechargeData.dart';
import 'package:rec/Helpers/Loading.dart';
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
                    onChange: (v) {
                      setState(
                        () => rechargeData.amount =
                            double.parse(v.isEmpty ? '0' : v),
                      );
                    },
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
                    onPressed: rechargeData.amount >= 1 ? _forwards : null,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  // TODO: refactor
  void _forwards() {
    if (!_formKey.currentState.validate()) return;

    Loading.show();
    _updateTos();

    var activeCampaign = CampaignProvider.of(
      context,
      listen: false,
    ).activeCampaign;

    rechargeData.card = null;
    rechargeData.saveCard = false;
    rechargeData.willEnterCampaign = rechargeData.campaignTermsAccepted &&
        rechargeData.amount >= activeCampaign.min;

    Loading.dismiss();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RequestPin(
          ifPin: (pin) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => AttemptRecharge(
                  data: rechargeData..pin = pin,
                ),
              ),
            );
          },
        ),
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
