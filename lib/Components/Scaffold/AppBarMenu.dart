import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/routes.dart';

class AppBarMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppBarMenu();
  }
}

class _AppBarMenu extends State<AppBarMenu> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var appState = AppState.of(context);
    var userState = UserState.of(context);

    return PopupMenuButton<dynamic>(
      itemBuilder: (BuildContext ctx) => [
        PopupMenuItem(
          child: Text('REC App - ${appState.version}'),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          child: InkWell(
            onTap: () async {
              await Auth.logout();
              userState.clear();
              await Navigator.of(context).pushReplacementNamed(Routes.login);
            },
            child: Text(localizations.translate('LOG_OUT')),
          ),
        ),
      ],
    );
  }
}
