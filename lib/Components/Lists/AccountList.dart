import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/AccountListTile.dart';
import 'package:rec/Components/Layout/InfoSplash.dart';
import 'package:rec/Components/Lists/SearchableList.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Providers/UserState.dart';

class AccountList extends StatefulWidget {
  final Function(Account account) onPick;

  const AccountList({Key key, this.onPick}) : super(key: key);

  @override
  _AccountList createState() => _AccountList();
}

class _AccountList extends State<AccountList> {
  List<Widget> searchedAccountsWidgets = [];
  String searchQuery = '';

  Widget _noItems(List<Account> accounts) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: InfoSplash(
        icon: Icons.import_contacts_outlined,
        title: accounts.length > 1 ? 'NO_ACCOUNTS_FOUND' : 'ONLY_ONE_ACCOUNT',
      ),
    );
  }

  void _updateAccounts(List<Account> accounts) {
    var userState = UserState.of(context, listen: false);

    setState(
      () => searchedAccountsWidgets = accounts
          .where((element) => element.id != userState.account.id)
          .where(_accountMatchesSearchQuery)
          .map(
            (account) => AccountListTile.fromAccount(
              account,
              onTap: () => widget.onPick(account),
            ),
          )
          .toList(),
    );
  }

  bool _accountMatchesSearchQuery(Account account) {
    return account.name.toLowerCase().contains(searchQuery.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context, listen: false);
    var accounts = userState.user.accounts;

    _updateAccounts(accounts);

    return SearchableList(
      searchHintText: 'SEARCH_ACCOUNTS',
      noItemsWidget: _noItems(accounts),
      items: searchedAccountsWidgets,
      search: (query) {
        searchQuery = query;
        _updateAccounts(accounts);
      },
    );
  }
}
