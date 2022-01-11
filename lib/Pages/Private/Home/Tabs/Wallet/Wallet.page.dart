import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/Components/Wallet/WalletFloatingActions.dart';
import 'package:rec/Entities/Transactions/Currency.ent.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/transactions/TransactionsList.tab.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/CampaignProvider.dart';
import 'package:rec/Providers/UserState.dart';

class WalletPageRec extends StatefulWidget {
  final bool autoReloadEnabled;

  WalletPageRec({
    Key key,
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
    var activeCampaign = CampaignProvider.of(context).activeCampaign;

    var isInCampaign = userState.user.hasCampaignAccount();
    var campaignAccount = userState.user.getCampaignAccount();
    var campaignActive = activeCampaign != null && !activeCampaign.isFinished();

    var showReedemable = campaignActive && isInCampaign;
    var redemableAmountText = showReedemable
        ? localizations.translate(
            'YOU_HAVE_RECS_REDEMABLE',
            params: {
              'amount': Currency.format(campaignAccount.redeemableAmount * 1.0),
            },
          )
        : '';

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
              label: showReedemable ? redemableAmountText : 'TOTAL_BALANCE',
              balance: userState.account?.getWalletByCurrency(Currency.rec)?.getScaledBalance(),
              hidable: true,
            ),
          ),
        ),
        floatingActionButton: WalletFloatingActions(
          isDialOpen: isDialOpen,
        ),
        body: TransactionsList(
          autoReloadEnabled: widget.autoReloadEnabled,
        ),
      ),
    );
  }
}
