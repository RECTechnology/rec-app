import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';

class NoItemsMessage extends StatelessWidget {
  final String title;
  final String subtitle;

  const NoItemsMessage({Key? key, required this.title, required this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final recTheme = RecTheme.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * .6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LocalizedText(
            'NO_CHALLENGES',
            style: textTheme.headline4!.copyWith(
              color: recTheme!.grayDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LocalizedText('NO_CHALLENGES_DESC', style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
