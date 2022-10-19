import 'package:flutter/material.dart';
import 'package:rec/Components/Info/no_items_message.dart';
import 'package:rec/Components/ListTiles/reward_tile.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/info_badge.dart';
import 'package:rec/Pages/Private/Home/Tabs/challenges/reward_details.page.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/providers/challenge_provider.dart';
import 'package:rec/providers/user_state.dart';

class RewardsTab extends StatefulWidget {
  RewardsTab({Key? key}) : super(key: key);

  @override
  State<RewardsTab> createState() => _RewardsTabState();
}

class _RewardsTabState extends State<RewardsTab> {
  ChallengesProvider? challengeProvider;
  UserState? userState;

  @override
  void didChangeDependencies() {
    if (challengeProvider == null && userState == null) {
      challengeProvider ??= ChallengesProvider.of(context);
      userState ??= UserState.of(context);

      _load();
    }

    super.didChangeDependencies();
  }

  Future _load() async {
    await challengeProvider!.loadAccountChallenges();
    await userState!.getUserResume();
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    return RefreshIndicator(
      color: recTheme!.primaryColor,
      onRefresh: _load,
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
                label: 'AMOUNT_SPENT',
                value: '${userState?.userResume?.totalSpent ?? 0} R',
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
                label: 'PURCHASES',
                value: '${userState?.userResume?.totalPurchases ?? 0}',
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
                label: 'COMPLETED_CHALLENGES',
                value: '${userState?.userResume?.completedChallenges ?? 0}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
