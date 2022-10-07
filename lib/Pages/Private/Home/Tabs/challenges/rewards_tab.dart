import 'package:flutter/material.dart';
import 'package:rec/Components/Info/no_items_message.dart';
import 'package:rec/Components/ListTiles/reward_tile.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/info_badge.dart';
import 'package:rec/Pages/Private/Home/Tabs/challenges/reward_details.page.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/providers/challenge_provider.dart';

class RewardsTab extends StatefulWidget {
  RewardsTab({Key? key}) : super(key: key);

  @override
  State<RewardsTab> createState() => _RewardsTabState();
}

class _RewardsTabState extends State<RewardsTab> {
  ChallengesProvider? challengeProvider;

  @override
  void didChangeDependencies() {
    if (challengeProvider == null) {
      challengeProvider = ChallengesProvider.of(context);
      challengeProvider!.loadAccountChallenges();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    return RefreshIndicator(
      color: recTheme!.primaryColor,
      onRefresh: () => challengeProvider!.loadAccountChallenges(),
      child: _content(),
    );
  }

  Widget _content() {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        LocalizedText('MY_PURCHASES', style: textTheme.subtitle1),
        const SizedBox(height: 16),
        _stats(),
        const SizedBox(height: 16),
        LocalizedText('REWARDS_DESC', style: textTheme.subtitle1),
        const SizedBox(height: 16),
        if (challengeProvider!.isLoading && challengeProvider!.accountChallenges.isNotEmpty)
          CircularProgressIndicator(),
        if (challengeProvider!.accountChallenges.isEmpty)
          SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            child: NoItemsMessage(
              title: 'NO_REWARDS',
              subtitle: 'NO_REWARDS_DESC',
            ),
          ),
        if (challengeProvider!.accountChallenges.isNotEmpty)
          Wrap(
            children: challengeProvider!.accountChallenges.map((challenge) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16, right: 32),
                child: RewardTile(
                  reward: challenge.tokenReward,
                  onTap: () {
                    RecNavigation.navigate(
                      context,
                      (context) => RewardDetailsPage(reward: challenge.tokenReward),
                    );
                  },
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  _stats() {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabelValueBadge(
                label: 'RECs gastados',
                value: '6.543,14 R',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabelValueBadge(
                label: 'Compras',
                value: '54',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabelValueBadge(
                label: 'Retos completados',
                value: '3',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
