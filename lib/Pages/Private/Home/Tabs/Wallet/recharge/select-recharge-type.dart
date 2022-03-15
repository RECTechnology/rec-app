import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/ListTiles/OutlinedListTile.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/All.dart';
import 'package:rec/providers/campaign-manager.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class SelectRechargePage extends StatefulWidget {
  @override
  _SelectRechargePageState createState() => _SelectRechargePageState();
}

class _SelectRechargePageState extends State<SelectRechargePage> {
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
            balance: 0,
            label: 'TOTAL_RECHARGE',
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    var user = UserState.of(context).user;
    var cultureAccount = user!.getAccountForCampaign(env.CMP_CULT_CODE);
    var hasCultureAccount = cultureAccount != null;

    return hasCultureAccount ? _hasCultureAccountLayout() : _hasNoCultureAccountLayout();
  }

  Widget _hasCultureAccountLayout() {
    var cultureCampaign = CampaignProvider.of(context).getCampaignByCode(env.CMP_CULT_CODE);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocalizedText(
            'SELECT_RECHARGE_HAS_CULTURE_DESC',
            style: TextStyle(
              fontSize: 13,
              color: Brand.grayDark2,
            ),
            params: {
              'percent': cultureCampaign!.percent,
            },
          ),
          const SizedBox(height: 16),
          OutlinedListTile(
            onPressed: _rechargeNormal,
            children: [
              const SizedBox(),
              LocalizedText(
                'I_DONT_WANT_TO',
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: Brand.grayDark, fontSize: 16),
              ),
              const SizedBox(),
            ],
          ),
          RecActionButton(
            label: 'REC_CULTURE',
            icon: Icons.arrow_forward_ios_sharp,
            onPressed: _goToCultureRecharge,
            padding: EdgeInsets.only(top: 12),
          )
        ],
      ),
    );
  }

  Widget _hasNoCultureAccountLayout() {
    var cultureCampaign = CampaignProvider.of(context).getCampaignByCode(env.CMP_CULT_CODE);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocalizedText(
                'SELECT_RECHARGE_HAS_NO_CULTURE_DESC',
                style: TextStyle(
                  fontSize: 13,
                  color: Brand.grayDark2,
                ),
                params: {
                  'percent': cultureCampaign!.percent,
                },
              ),
              const SizedBox(height: 16),
              RecActionButton(
                label: 'REC_CULTURE',
                icon: Icons.arrow_forward_ios_sharp,
                onPressed: _goToParticipate,
                padding: EdgeInsets.only(top: 12),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocalizedText(
                'SELECT_RECHARGE_HAS_NO_CULTURE_OMIT_DESC',
                style: TextStyle(
                  fontSize: 13,
                  color: Brand.grayDark2,
                ),
                params: {
                  'percent': cultureCampaign.percent,
                },
              ),
              RecActionButton(
                label: 'OMIT',
                icon: Icons.arrow_forward_ios_sharp,
                onPressed: _rechargeNormal,
                padding: EdgeInsets.only(top: 12),
              )
            ],
          ),
        ],
      ),
    );
  }

  _rechargeNormal() {
    Navigator.of(context).pushNamed(Routes.recharge);
  }

  _goToParticipate() {
    var campaignManager = CampaignManager.deaf(context);
    var cultureDefinition = campaignManager.getDefinition(env.CMP_CULT_CODE);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => cultureDefinition!.participateBuilder(
          context,
          {'hideDontShowAgain': true},
        ),
      ),
    );
  }

  _goToCultureRecharge() async {
    var userState = UserState.deaf(context);
    var account = userState.user!.getAccountForCampaign(env.CMP_CULT_CODE)!;

    await selectAccount(account);

    await Navigator.of(context).pushReplacementNamed(Routes.recharge);
  }

  // TODO: look at a way of centralizing this, it's used here and in account selector modal
  Future selectAccount(Account account) {
    var userState = UserState.deaf(context);
    if (userState.account!.id == account.id) {
      return Future.value(null);
    }

    Loading.show();

    return userState.userService
        .selectMainAccount(account.id)
        .then((_) => onAccountChange(account))
        .catchError((e) => onAccountChangeError(e));
  }

  void onAccountChange(Account account) {
    var userState = UserState.of(context, listen: false);
    var transactionsProvider = TransactionProvider.of(context, listen: false);

    userState.setSelectedAccount(account);
    transactionsProvider.refresh();
    Loading.dismiss();
  }

  void onAccountChangeError(error) {
    Loading.dismiss();
    RecToast.showError(context, error.message);
  }
}
