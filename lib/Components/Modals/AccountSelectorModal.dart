import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/ListTiles/AccountListTile.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/conditionals/show_if_roles.dart';
import 'package:rec/config/roles_definitions.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/challenge_provider.dart';
import 'package:rec/providers/transactions_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/styles/box_decorations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

// TODO: clean up this page, extract any widgets that could be reused
// TODO: Convert to Widget...
class AccountSelectorModal {
  final BuildContext context;
  final UsersService userService;

  AccountSelectorModal(
    this.context,
  ) : userService = UsersService(env: env);

  Widget dialogContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 8),
              LocalizedText(
                'MY_ACCOUNTS',
                style: Theme.of(context).textTheme.headline6,
              )
            ],
          ),
        ),
        currentAccount(),
        Expanded(child: accountList()),
        newAccountButton(),
      ],
    );
  }

  Widget newAccountButton() {
    final recTheme = RecTheme.of(context);

    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, Routes.settingsAddNewAccount);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: recTheme!.separatorColor,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(Icons.person_add),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: LocalizedText('ADD_ANOTHER_ACCOUNT'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget currentAccount() {
    final userState = UserState.of(context);
    final account = userState.user!.selectedAccount!;
    final isLtabAccount = userState.account!.isLtabAccount();
    final recTheme = RecTheme.of(context);

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 70),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: recTheme!.separatorColor,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatarRec(
                    imageUrl: account.companyImage,
                    name: account.name,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: LocalizedText(
                      account.name ?? '',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  )
                ],
              ),
              if (!isLtabAccount)
                ShowIfRoles(
                  validRoles: RoleDefinitions.manageAccount,
                  child: _manageAccountButton(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _manageAccountButton() {
    final recTheme = RecTheme.of(context);
    final userState = UserState.of(context);
    final account = userState.user!.selectedAccount!;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
          if (account.isPrivate()) {
            Navigator.pushNamed(context, Routes.settingsYourAccount);
          } else {
            Navigator.pushNamed(context, Routes.settingsBussinessAccount);
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1, color: recTheme!.grayDark2),
        ),
        child: LocalizedText(
          'MANAGE_ACCOUNT',
          style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget accountList() {
    final recTheme = RecTheme.of(context);
    final userState = UserState.of(context);
    final accounts = userState.user!.accounts
        .where(
          (element) => element.id != userState.account!.id && element.active!,
        )
        .toList();

    return Container(
      color: recTheme!.defaultAvatarBackground,
      child: accounts.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: LocalizedText(
                  'NO_MORE_ACCOUNTS',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: accounts.length,
              itemBuilder: (ctx, index) {
                var account = accounts[index];
                return AccountListTile(
                  onTap: () => selectAccount(account),
                  avatar: CircleAvatarRec.fromAccount(account),
                  name: account.name,
                );
              },
            ),
    );
  }

  void selectAccount(Account account) async {
    await Loading.show();
    await userService
        .selectMainAccount(account.id)
        .then((_) => onAccountChangeOk(account))
        .catchError((e) => onAccountChangeError(e));
  }

  void onAccountChangeError(error) {
    Loading.dismiss();
    closeModal();
    RecToast.showError(context, error.message);
  }

  void onAccountChangeOk(Account account) {
    onAccountChange(account);
    closeModal();
  }

  /// Method called once the account has changed
  /// I'm leaving this here, as account change will only happen here for now
  /// But if a better way is found this might be changed
  /// TODO: Look for a better way of updating this data
  void onAccountChange(Account account) async {
    final userState = UserState.of(context, listen: false);
    final transactionsProvider = TransactionProvider.of(context, listen: false);
    final challengeProvider = ChallengesProvider.of(context, listen: false);

    userState.setSelectedAccount(account);
    await userState.getUser();
    userState.getUserResume();
    transactionsProvider.refresh();
    challengeProvider.load();
    challengeProvider.loadAccountChallenges();

    Loading.dismiss();
  }

  void open() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          decoration: BoxDecorations.transparentBorder(),
          height: MediaQuery.of(context).size.height * 0.6,
          child: dialogContent(),
        ),
      ),
    );
  }

  void closeModal() {
    Navigator.of(context).pop();
  }
}
