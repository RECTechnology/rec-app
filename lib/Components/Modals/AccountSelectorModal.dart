import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/CircleAvatar.dart';
import 'package:rec/Helpers/Borders.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';

class AccountSelectorModal {
  final BuildContext context;
  AccountSelectorModal(this.context);

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
                    size: 35,
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
                  child: Text(localization.translate('MANAGE_ACCOUNT')),
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
    var accounts = userState.user.accounts;

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          leading: CircleAvatarRec(
            imageUrl: accounts[index].publicImage,
            name: accounts[index].name,
          ),
          title: Text(accounts[index].name),
        );
      },
    );
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
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
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
