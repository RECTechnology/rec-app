import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/Components/Wallet/WalletFloatingActions.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/transactions/TransactionsList.tab.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class WalletPageRec extends StatefulWidget {
  final bool autoReloadEnabled;

  WalletPageRec({
    Key? key,
    this.autoReloadEnabled = true,
  }) : super(key: key);

  @override
  _WalletPageRecState createState() => _WalletPageRecState();
}

class _WalletPageRecState extends State<WalletPageRec> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var localizations = AppLocalizations.of(context);
    var campaignProvider = CampaignProvider.of(context);

    var user = userState.user;
    var account = userState.account;
    var ltabCampaign = campaignProvider.getCampaignByCode(env.CMP_LTAB_CODE);

    var isCultureAccount = account!.isCampaignAccount(env.CMP_CULT_CODE);
    var isInLtabCampaign = user!.getCampaignAccount(env.LTAB_CAMPAIGN_ID as String) != null;
    var ltabCampaignAccount = user.getCampaignAccount(env.LTAB_CAMPAIGN_ID as String);

    var campaignActive = ltabCampaign != null && !ltabCampaign.isFinished();
    var showReedemable = campaignActive && isInLtabCampaign && !isCultureAccount;

    var redemableAmountText = showReedemable
        ? localizations!.translate(
            'YOU_HAVE_RECS_REDEMABLE',
            params: {
              'amount': Currency.format(
                ltabCampaignAccount!.redeemableAmount! * 1.0,
              ),
            },
          )
        : null;

    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
        }
        return false;
      },
      child: Scaffold(
        appBar: PrivateAppBar(
          size: 160,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: UserBalance(
              label: redemableAmountText ?? 'TOTAL_BALANCE',
              balance: userState.account?.getWalletByCurrency(Currency.rec).getScaledBalance(),
              hidable: true,
            ),
          ),
        ),
        floatingActionButton: WalletFloatingActions(isDialOpen: isDialOpen),
        body: TransactionsList(
          autoReloadEnabled: widget.autoReloadEnabled,
        ),
      ),
    );
  }
}
