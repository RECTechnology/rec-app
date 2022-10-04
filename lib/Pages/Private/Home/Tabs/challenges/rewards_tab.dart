import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';

class RewardsTab extends StatefulWidget {
  RewardsTab({Key? key}) : super(key: key);

  @override
  State<RewardsTab> createState() => _RewardsTabState();
}

class _RewardsTabState extends State<RewardsTab> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocalizedText('REWARDS_DESC', style: textTheme.subtitle1),
            const SizedBox(height: 16),
            ListView(
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
