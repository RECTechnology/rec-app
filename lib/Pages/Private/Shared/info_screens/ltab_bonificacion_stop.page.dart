import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/styles/text_styles.dart';

class LtabBonificacionStop extends StatefulWidget {
  final bool buttonWithArrow;

  const LtabBonificacionStop({
    Key? key,
    this.buttonWithArrow = true,
  }) : super(key: key);

  @override
  _LtabBonificacionStopState createState() => _LtabBonificacionStopState();
}

class _LtabBonificacionStopState extends State<LtabBonificacionStop> {
  Future<bool> _pop() {
    Navigator.of(context).pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _pop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: EmptyAppBar(
          context,
          backArrow: widget.buttonWithArrow,
          backAction: () {
            Navigator.of(context).popUntil(
              ModalRoute.withName(Routes.home),
            );
          },
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    var localizations = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(32, 32, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Center(
                child: LocalizedText(
                  'LTAB_STOP_BONIFICATION_TITLE',
                  style: TextStyles.pageTitle,
                  textAlign: TextAlign.center,
                  uppercase: true,
                ),
              ),
              SizedBox(height: 32),
              LocalizedText(
                'LTAB_STOP_BONIFICATION_DESC_1',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button!.copyWith(fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 16),
              LocalizedText(
                'LTAB_STOP_BONIFICATION_DESC_2',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button!.copyWith(fontWeight: FontWeight.normal),
              ),
            ],
          ),
          RecActionButton(
            label: localizations!.translate('ALRIGHT'),
            onPressed: _pop,
            icon: Icons.arrow_forward_ios,
          )
        ],
      ),
    );
  }
}
