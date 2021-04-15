import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/CircleAvatar.dart';
import 'package:rec/Components/ToastRec.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Helpers/Borders.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

// TODO: improve dialogs, this is kinda messy
class AccountSelectorModal {
  final BuildContext context;
  final UsersService userService;

  AccountSelectorModal(this.context) : userService = UsersService();

  Widget dialogContent() {
    var localization = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          localization.translate('MY_ACCOUNTS'),
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        bottom: currentAccount(),
      ),
      body: accountList(),
      bottomNavigationBar: newAccountButton(),
    );
  }

  Widget newAccountButton() {
    var localization = AppLocalizations.of(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(border: Borders.borderTop),
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(Icons.person_add),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  localization.translate('ADD_ANOTHER_ACCOUNT'),
                ),
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
    var localization = AppLocalizations.of(context);

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
                    child: Text(
                      account.name,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    primary: Brand.grayDark,
                    side: BorderSide(width: 1, color: Brand.grayDark2),
                  ),
                  child: Text(
                    localization.translate('MANAGE_ACCOUNT'),
                    style: TextStyle(color: Brand.grayDark2),
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

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (ctx, index) {
        var account = accounts[index];
        return ListTile(
          onTap: () => onSelected(account),
          leading: CircleAvatarRec.fromAccount(account),
          title: Text(account.name),
        );
      },
    );
  }

  void onSelected(Account account) async {
    await EasyLoading.show(status: 'Loading...');
    await userService
        .changeAccount(account.id)
        .then((_) => onAccountChangeOk(account))
        .catchError((e) => onAccountChangeError(e));
  }

  void onAccountChangeError(e) {
    EasyLoading.dismiss();
    closeModal();
    ToastRec.printToastRec(context, e['body']['status_text']);
  }

  void onAccountChangeOk(Account account) {
    onAccountChange(account);
    EasyLoading.dismiss();
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
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
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
