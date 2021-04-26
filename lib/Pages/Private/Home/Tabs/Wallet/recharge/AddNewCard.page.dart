import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({
    Key key,
  }) : super(key: key);

  @override
  _AddNewCardState createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(context),
      body: _body(),
    );
  }

  Widget _body() {
    var localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Column(
        children: [
          Center(
            child: Text(
              localizations.translate('SAVE_CREDIT_CARD'),
              style: TextStyles.pageTitle,
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: Text(
              localizations.translate('SAVE_CREDIT_CARD_DESC'),
              textAlign: TextAlign.center,
              style: TextStyles.pageSubtitle1,
            ),
          ),
          SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.0, color: Brand.grayDark2),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        localizations.translate('NO'),
                        style: TextStyle(color: Brand.grayDark2),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.0, color: Brand.grayDark2),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        localizations.translate('YES'),
                        style: TextStyle(color: Brand.grayDark2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
