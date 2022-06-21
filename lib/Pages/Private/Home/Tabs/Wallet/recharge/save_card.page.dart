import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/OutlinedListTile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/brand.dart';

/// Asks the user if they want to save the new card or not
///
/// Can pop with:
/// * [bool] -> if they want to save the new card or not
/// * [null] -> No action clicked
class SaveCardPage extends StatelessWidget {
  const SaveCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LocalizedText(
                'SAVE_CREDIT_CARD',
                style: TextStyle(
                  fontSize: 20,
                  color: Brand.grayDark,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              LocalizedText(
                'SAVE_CREDIT_CARD_DESC',
                style: TextStyle(
                  fontSize: 20,
                  color: Brand.grayDark2,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: OutlinedListTile(
                      mainAxisAlignment: MainAxisAlignment.center,
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      children: [
                        LocalizedText(
                          'YES',
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: Brand.grayDark, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedListTile(
                      mainAxisAlignment: MainAxisAlignment.center,
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      children: [
                        LocalizedText(
                          'NO',
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: Brand.grayDark, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
