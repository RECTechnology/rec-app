import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/routes.dart';

class LtabBonificacionStop extends StatefulWidget {
  final bool buttonWithArrow;

  const LtabBonificacionStop({
    Key key,
    this.buttonWithArrow = true,
  }) : super(key: key);

  @override
  _LtabBonificacionStopState createState() => _LtabBonificacionStopState();
}

class _LtabBonificacionStopState extends State<LtabBonificacionStop> {
  Future<bool> _popBackHome() {
    Navigator.of(context).popUntil(
      ModalRoute.withName(Routes.home),
    );
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _popBackHome,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: EmptyAppBar(
          context,
          backArrow: widget.buttonWithArrow,
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    var localizations = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(32, 84, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Center(
                child: Text(
                  localizations.translate('LTAB_STOP_BONIFICATION_TITLE'),
                  style: TextStyles.pageTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: Text(
                  localizations.translate('LTAB_STOP_BONIFICATION_DESC'),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          RecActionButton(
            label: localizations.translate('ALRIGHT'),
            onPressed: _popBackHome,
          )
        ],
      ),
    );
  }
}
