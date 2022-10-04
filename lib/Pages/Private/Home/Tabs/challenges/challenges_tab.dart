import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/challenge_list_tile.dart';
import 'package:rec/Components/Lists/list_view_extra.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/challenge_provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ChallengesTab extends StatefulWidget {
  ChallengesTab({Key? key}) : super(key: key);

  @override
  State<ChallengesTab> createState() => _ChallengesTabState();
}

class _ChallengesTabState extends State<ChallengesTab> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final recTheme = RecTheme.of(context);
    final challengeProvider = ChallengesProvider.of(context);
    final challenges = challengeProvider.pendingChallenges ?? [];

    return RefreshIndicator(
      color: recTheme!.primaryColor,
      onRefresh: () => challengeProvider.loadPending(),
      child: ListViewExtra(
        itemCount: challenges.length,
        padding: EdgeInsets.all(16),
        headerBuilder: (context) {
          return LocalizedText('CHALLENGES_DESC', style: textTheme.subtitle1);
        },
        itemBuilder: (context, index) {
          return ChallengeListTile(
            challenge: challenges[index],
          );
        },
        noItemsBuilder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LocalizedText(
                  'NO_CHALLENGES',
                  style: textTheme.headline4!.copyWith(
                    color: recTheme.grayDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LocalizedText('NO_CHALLENGES_DESC', style: textTheme.bodyMedium),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(height: 16),
      ),
    );
  }
}
