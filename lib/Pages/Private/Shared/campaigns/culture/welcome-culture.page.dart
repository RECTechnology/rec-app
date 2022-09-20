import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LinkText.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/transactions_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CultureWelcomePage extends StatefulWidget {
  const CultureWelcomePage({
    Key? key,
  }) : super(key: key);

  @override
  _CultureWelcomePageState createState() => _CultureWelcomePageState();
}

class _CultureWelcomePageState extends State<CultureWelcomePage> {
  Future<bool> _popBackHome() {
    Navigator.of(context).popUntil(ModalRoute.withName(Routes.home));
    return Future.value(false);
  }

  _goToRecharge() async {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _popBackHome,
      child: Scaffold(
        appBar: EmptyAppBar(context),
        backgroundColor: Colors.white,
        body: _body(),
      ),
    );
  }

  Widget _body() {
    final activeCampaign = CampaignProvider.of(context).getCampaignByCode(env.CMP_CULT_CODE);
    final localizations = AppLocalizations.of(context);
    final recTheme = RecTheme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(32, 24, 32, 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Center(
                child: LocalizedText(
                  'ALREADY_A_PART_OF',
                  params: {
                    'campaign': activeCampaign!.name!.toUpperCase(),
                  },
                  style: recTheme!.textTheme.pageTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: LocalizedText(
                  'CAMPAIGN_CULT21_DESC',
                  style: recTheme.textTheme.pageSubtitle1,
                  textAlign: TextAlign.center,
                  params: {
                    'percent': activeCampaign.percent,
                  },
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              height: 194,
              width: 194,
              child: Image.network(activeCampaign.imageUrl!),
            ),
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinkText("CAMPAIGN_SITE", onTap: () {
                InAppBrowser.openLink(
                  context,
                  localizations!.translate('link_culture'),
                  title: activeCampaign.name!,
                );
              }),
            ],
          ),
          RecActionButton(
            label: 'RECHARGE',
            onPressed: _goToRecharge,
          ),
        ],
      ),
    );
  }
}
