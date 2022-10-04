import 'package:flutter/material.dart';
import 'package:rec/Components/Info/no_items_message.dart';
import 'package:rec/Components/ListTiles/reward_tile.dart';
import 'package:rec/Components/Lists/list_view_extra.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/info_badge.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/reward_provider.dart';

class RewardsTab extends StatefulWidget {
  RewardsTab({Key? key}) : super(key: key);

  @override
  State<RewardsTab> createState() => _RewardsTabState();
}

class _RewardsTabState extends State<RewardsTab> {
  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final rewardProvider = RewardsProvider.of(context);

    return RefreshIndicator(
      color: recTheme!.primaryColor,
      onRefresh: () => rewardProvider.loadPending(),
      child: _content(),
    );
  }

  Widget _content() {
    final textTheme = Theme.of(context).textTheme;
    final recTheme = RecTheme.of(context);
    final rewardProvider = RewardsProvider.of(context);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: recTheme!.primaryColor),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          LocalizedText('MY_PURCHASES', style: textTheme.subtitle1),
          const SizedBox(height: 16),
          _stats(),
          const SizedBox(height: 16),
          LocalizedText('REWARDS_DESC', style: textTheme.subtitle1),
          const SizedBox(height: 16),
          if (rewardProvider.pendingRewards!.isEmpty)
            NoItemsMessage(
              title: 'NO_REWARDS',
              subtitle: 'NO_REWARDS_DESC',
            ),
          if (rewardProvider.pendingRewards!.isNotEmpty)
            Wrap(
              children: rewardProvider.pendingRewards!.map((reward) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 32),
                  child: RewardTile(reward: reward),
                );
              }).toList(),
            ),
        ],
      ),
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
