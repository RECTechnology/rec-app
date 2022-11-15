import 'package:flutter/material.dart';
import 'package:rec/Components/Info/no_items_message.dart';
import 'package:rec/Components/ListTiles/challenge_list_tile.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/challenge_provider.dart';

class ChallengesTab extends StatefulWidget {
  ChallengesTab({Key? key}) : super(key: key);

  @override
  State<ChallengesTab> createState() => _ChallengesTabState();
}

class _ChallengesTabState extends State<ChallengesTab> {
  ChallengesProvider? challengeProvider;

  @override
  void didChangeDependencies() {
    if (challengeProvider == null) {
      challengeProvider = ChallengesProvider.of(context);
      challengeProvider!.load();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final recTheme = RecTheme.of(context);
    final challengeProvider = ChallengesProvider.of(context);
    final challenges = challengeProvider.challenges;

    return RefreshIndicator(
      color: recTheme!.primaryColor,
      onRefresh: () => challengeProvider.load(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LocalizedText('CHALLENGES_DESC', style: textTheme.subtitle1),
          ),
          if (challengeProvider.isLoading && challengeProvider.challenges.isEmpty)
            Column(
              children: [CircularProgressIndicator()],
            ),
          if (challengeProvider.challenges.isNotEmpty)
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(16),
                itemBuilder: (_, index) {
                  return ChallengeListTile(
                    challenge: challenges[index],
                  );
                },
                separatorBuilder: (_, __) => SizedBox(height: 16),
                itemCount: challenges.length,
              ),
            ),
          if (!challengeProvider.isLoading && challengeProvider.challenges.isEmpty)
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .6,
                    child: NoItemsMessage(
                      title: 'NO_CHALLENGES',
                      subtitle: 'NO_CHALLENGES_DESC',
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
