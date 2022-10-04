import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/challenge_list_tile.dart';
import 'package:rec/Components/Lists/list_view_extra.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ChallengesTab extends StatefulWidget {
  ChallengesTab({Key? key}) : super(key: key);

  @override
  State<ChallengesTab> createState() => _ChallengesTabState();
}

class _ChallengesTabState extends State<ChallengesTab> {
  final testChallenges = [
    // Challenge(
    //   status: ChallengeStatus.OPEN,
    //   action: ChallengeAction.BUY,
    //   title: 'Gasta 10R en tiendas que vendan productos ecológicosecológico ',
    //   description:
    //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis sed nisi tincidunt, tincidunt ex non, sollicitudin turpis. Fusce libero dui, egestas ac vehicula sit amet, viverra at elit. Proin consectetur lectus sed ex rhoncus, in sodales purus sodales. Pellentesque ut tortor euismod',
    //   coverImage:
    //       'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2013%2F11%2F341164%2Cxcitefun-waterfalls-of-gods-iceland-1.jpg&f=1&nofb=1&ipt=5a5696c924ea46f3fc3a148fe5f1f06df5e59840c7380e38cde8215cbc3bbe66&ipo=images',
    //   threshold: 0,
    //   amountRequired: 32,
    //   startDate: DateTime(2022, 10, 3, 8, 30),
    //   endDate: DateTime(2022, 10, 6, 12, 30),
    //   activities: [],
    //   tokenReward: TokenReward(
    //     description: 'dsaadsdasads',
    //     image:
    //         'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2013%2F11%2F341164%2Cxcitefun-waterfalls-of-gods-iceland-1.jpg&f=1&nofb=1&ipt=5a5696c924ea46f3fc3a148fe5f1f06df5e59840c7380e38cde8215cbc3bbe66&ipo=images',
    //     name: 'asddadas',
    //     status: 'dasdasdas',
    //     tokenId: 'asdadsads',
    //   ),
    //   owner: Account(),
    // ),
    // Challenge(
    //   status: ChallengeStatus.OPEN,
    //   action: ChallengeAction.BUY,
    //   title: 'REALIZA 2 COMPRAS EN TIENDAS QUE VENDAN PRODUCTO A GRANEL',
    //   description:
    //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis sed nisi tincidunt, tincidunt ex non, sollicitudin turpis. Fusce libero dui, egestas ac vehicula sit amet, viverra at elit.',
    //   coverImage:
    //       'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fwallsdesk.com%2Fwp-content%2Fuploads%2F2018%2F03%2FElk-Pictures.jpg&f=1&nofb=1&ipt=6ad8b2dc48daa255ca18eab9e1e94632d6126c24e653800bf6ef96ffee30876c&ipo=images',
    //   threshold: 4,
    //   amountRequired: 0,
    //   startDate: DateTime(2022, 10, 3, 8, 30),
    //   endDate: DateTime(2022, 10, 12, 12, 30),
    //   activities: [],
    //   tokenReward: TokenReward(
    //     description: 'dsaadsdasads',
    //     image:
    //         'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2013%2F11%2F341164%2Cxcitefun-waterfalls-of-gods-iceland-1.jpg&f=1&nofb=1&ipt=5a5696c924ea46f3fc3a148fe5f1f06df5e59840c7380e38cde8215cbc3bbe66&ipo=images',
    //     name: 'asddadas',
    //     status: 'dasdasdas',
    //     tokenId: 'asdadsads',
    //   ),
    //   owner: Account(),
    // )
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final recTheme = RecTheme.of(context);

    return RefreshIndicator(
      color: recTheme!.primaryColor,
      onRefresh: () {
        return Future.delayed(Duration(seconds: 4));
      },
      child: ListViewExtra(
        itemCount: testChallenges.length,
        padding: EdgeInsets.all(16),
        headerBuilder: (context) {
          return LocalizedText('CHALLENGES_DESC', style: textTheme.subtitle1);
        },
        itemBuilder: (context, index) {
          return ChallengeListTile(
            challenge: testChallenges[index],
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
