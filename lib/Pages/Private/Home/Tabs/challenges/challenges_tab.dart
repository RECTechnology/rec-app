import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/challenge_list_tile.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ChallengesTab extends StatefulWidget {
  ChallengesTab({Key? key}) : super(key: key);

  @override
  State<ChallengesTab> createState() => _ChallengesTabState();
}

class _ChallengesTabState extends State<ChallengesTab> {
  final testChallenges = [
    Challenge(
      status: ChallengeStatus.OPEN,
      action: ChallengeAction.BUY,
      title: 'Gasta 10R en tiendas que vendan productos ecológicosecológico ',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis sed nisi tincidunt, tincidunt ex non, sollicitudin turpis. Fusce libero dui, egestas ac vehicula sit amet, viverra at elit. Proin consectetur lectus sed ex rhoncus, in sodales purus sodales. Pellentesque ut tortor euismod',
      coverImage:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2013%2F11%2F341164%2Cxcitefun-waterfalls-of-gods-iceland-1.jpg&f=1&nofb=1&ipt=5a5696c924ea46f3fc3a148fe5f1f06df5e59840c7380e38cde8215cbc3bbe66&ipo=images',
      threshold: 10,
      amountRequired: 10,
      startDate: DateTime(2022, 10, 3, 8, 30),
      endDate: DateTime(2022, 10, 6, 12, 30),
      activities: [],
      tokenReward: TokenReward(
        description: 'dsaadsdasads',
        image:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2013%2F11%2F341164%2Cxcitefun-waterfalls-of-gods-iceland-1.jpg&f=1&nofb=1&ipt=5a5696c924ea46f3fc3a148fe5f1f06df5e59840c7380e38cde8215cbc3bbe66&ipo=images',
        name: 'asddadas',
        status: 'dasdasdas',
        tokenId: 'asdadsads',
      ),
      owner: Account(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        LocalizedText('CHALLENGES_DESC', style: textTheme.subtitle1),
        const SizedBox(height: 16),
        ChallengeListTile(
          challenge: testChallenges.first,
        ),
      ],
    );
  }
}
