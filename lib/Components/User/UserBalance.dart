import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Helpers/Formatting.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';

class UserBalance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserBalance();
  }
}

class _UserBalance extends State<UserBalance> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var userState = UserState.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              Formatting.formatCurrency(1000),
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              localizations.translate('ACTUAL_BALANCE').toUpperCase(),
              style: TextStyle(fontSize: 15, color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }
}
