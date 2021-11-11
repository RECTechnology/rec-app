import 'package:flutter/material.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/ListTiles/AccountListTile.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Pages/Private/Home/Home.page.dart';
import 'package:rec/Styles/Borders.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/BoxDecorations.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

// TODO: clean up this page, extract any widgets that could be reused
class AccountSelectorModal {
  final BuildContext context;
  final UsersService userService;

  AccountSelectorModal(
    this.context,
  ) : userService = UsersService();

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
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, Routes.settingsAddNewAccount);
        },
        child: Container(
          decoration: BoxDecoration(border: Borders.borderTop),
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
    var userState = UserState.of(context);
    var account = userState.user.selectedAccount;
    var isLtabAccount = userState.account.isLtabAccount();

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 70),
      child: Container(
        decoration: BoxDecoration(border: Borders.borderBottom),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatarRec(
                    imageUrl: account.publicImage,
                    name: account.name,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: LocalizedText(
                      account.name,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  )
                ],
              ),
              if (!isLtabAccount)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      HomePageState.changeTab(context, 2);
                    },
                    style: OutlinedButton.styleFrom(
                      primary: Brand.grayDark,
                      side: BorderSide(width: 1, color: Brand.grayDark2),
                    ),
                    child: LocalizedText(
                      'MANAGE_ACCOUNT',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget accountList() {
    var userState = UserState.of(context);
    var accounts = userState.user.accounts
        .where(
          (element) => element.id != userState.account.id && element.active,
        )
        .toList();

    return Container(
      color: Brand.defaultAvatarBackground,
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
                  onTap: () => onSelected(account),
                  avatar: CircleAvatarRec.fromAccount(account),
                  name: account.name,
                );
              },
            ),
    );
  }

  void onSelected(Account account) async {
    await Loading.show();
    await userService
        .changeAccount(account.id)
        .then((_) => onAccountChangeOk(account))
        .catchError((e) => onAccountChangeError(e));
  }

  void onAccountChangeError(error) {
    Loading.dismiss();
    closeModal();
    RecToast.show(context, error.message);
  }

  void onAccountChangeOk(Account account) {
    onAccountChange(account);
    Loading.dismiss();
    closeModal();
  }

  /// Method called once the account has changed
  /// I'm leaving this here, as account change will only happen here
  /// But if a better way is found this might be changed
  void onAccountChange(Account account) {
    var userState = UserState.of(context, listen: false);
    var transactionsProvider = TransactionProvider.of(context, listen: false);

    userState?.setSelectedAccount(account);
    transactionsProvider?.refresh();
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
