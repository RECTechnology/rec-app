import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class MainAccountPage extends StatefulWidget {
  MainAccountPage({Key key}) : super(key: key);

  @override
  _MainAccountPageState createState() => _MainAccountPageState();
}

class _MainAccountPageState extends State<MainAccountPage> {
  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var theme = Theme.of(context);
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(context, title: 'PRINCIPAL_ACCOUNT'),
      body: Scrollbar(
        thickness: 8,
        showTrackOnHover: true,
        radius: Radius.circular(3),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 8),
              child: Text(
                localizations.translate('ACCOUNT_RECIVE_RECS'),
                style: theme.textTheme.subtitle1
                    .copyWith(fontWeight: FontWeight.w300, fontSize: 16),
              ),
            ),
            GeneralSettingsTile(
              title: userState.account.name,
              subtitle: localizations.translate('PRINCIPAL_ACCOUNT'),
              circleAvatar: CircleAvatarRec.fromAccount(
                userState.account,
                radius: 27,
              ),
              titleStyle: theme.textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.w500,
                color: Brand.grayDark,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 22,
              ),
              child: SectionTitleTile(
                localizations.translate('AVARIABLE'),
              ),
            ),
            Container(
              child: accountList(),
            ),
            const SizedBox(
              height: 16,
            )
          ],
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
    var theme = Theme.of(context);

    return Container(
      width: 500,
      height: 500,
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: accounts.length,
        itemBuilder: (ctx, index) {
          var account = accounts[index];
          return GeneralSettingsTile(
            title: account.name,
            onTap: () => onSelectedAccount(account),
            circleAvatar: CircleAvatarRec.fromAccount(account),
            titleStyle: theme.textTheme.subtitle1.copyWith(
              fontWeight: FontWeight.w300,
            ),
          );
        },
      ),
    );
  }

  void onSelectedAccount(Account account) {
    var userService = UsersService();

    userService.changeAccount(account.id).then((_) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    }).catchError((Object error) {});
  }
}
