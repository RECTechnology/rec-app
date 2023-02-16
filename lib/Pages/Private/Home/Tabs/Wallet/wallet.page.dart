import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Wallet/user_balance.dart';
import 'package:rec/Components/Wallet/wallet_floating_actions.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/transactions/TransactionsList.tab.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/app_localizations.dart';
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
    final userState = UserState.of(context);
    final localizations = AppLocalizations.of(context);
    final campaignProvider = CampaignProvider.of(context);

    final user = userState.user;
    final account = userState.account;
    final ltabCampaign = campaignProvider.getCampaignByCode(env.CMP_LTAB_CODE);

    final isCultureAccount = account!.isCampaignAccount(env.CMP_CULT_CODE);
    final isInLtabCampaign = user!.getCampaignAccount(env.LTAB_CAMPAIGN_ID as String) != null;
    final ltabCampaignAccount = user.getCampaignAccount(env.LTAB_CAMPAIGN_ID as String);

    final campaignActive = ltabCampaign != null && !ltabCampaign.isFinished();
    final showReedemable = campaignActive && isInLtabCampaign && !isCultureAccount;

    final redemableAmountText = showReedemable
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
              balance:
                  userState.account?.getWalletByCurrencyName(env.CURRENCY_NAME).getScaledBalance(),
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
