import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ChallengesProvider extends ChangeNotifier {
  final ChallengesService _service;

  List<Challenge> challenges = [
    // Challenge(
    //   status: ChallengeStatus.OPEN,
    //   action: ChallengeAction.BUY,
    //   type: ChallengeType.CHALLENGE,
    //   title: 'Gasta 10R en tiendas que vendan productos ecológicosecológico ',
    //   description:
    //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis sed nisi tincidunt, tincidunt ex non, sollicitudin turpis. Fusce libero dui, egestas ac vehicula sit amet, viverra at elit. Proin consectetur lectus sed ex rhoncus, in sodales purus sodales. Pellentesque ut tortor euismod',
    //   coverImage:
    //       'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2013%2F11%2F341164%2Cxcitefun-waterfalls-of-gods-iceland-1.jpg&f=1&nofb=1&ipt=5a5696c924ea46f3fc3a148fe5f1f06df5e59840c7380e38cde8215cbc3bbe66&ipo=images',
    //   threshold: 0,
    //   amountRequired: 32,
    //   startDate: DateTime(2022, 10, 3, 8, 30),
    //   finishDate: DateTime(2022, 10, 6, 12, 30),
    //   activities: [],
    //   tokenReward: TokenReward(
    //     description: 'dsaadsdasads',
    //     image:
    //         'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2013%2F11%2F341164%2Cxcitefun-waterfalls-of-gods-iceland-1.jpg&f=1&nofb=1&ipt=5a5696c924ea46f3fc3a148fe5f1f06df5e59840c7380e38cde8215cbc3bbe66&ipo=images',
    //     name: 'asddadas',
    //     status: 'dasdasdas',
    //     tokenId: 'asdadsads',
    //     authorUrl: 'https://external-content.duckduckgo.com',
    //   ),
    //   owner: Account(),
    // ),
    // Challenge(
    //   status: ChallengeStatus.OPEN,
    //   action: ChallengeAction.BUY,
    //   type: ChallengeType.CHALLENGE,
    //   title: 'REALIZA 2 COMPRAS EN TIENDAS QUE VENDAN PRODUCTO A GRANEL',
    //   description:
    //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis sed nisi tincidunt, tincidunt ex non, sollicitudin turpis. Fusce libero dui, egestas ac vehicula sit amet, viverra at elit.',
    //   coverImage:
    //       'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fwallsdesk.com%2Fwp-content%2Fuploads%2F2018%2F03%2FElk-Pictures.jpg&f=1&nofb=1&ipt=6ad8b2dc48daa255ca18eab9e1e94632d6126c24e653800bf6ef96ffee30876c&ipo=images',
    //   threshold: 4,
    //   amountRequired: 0,
    //   startDate: DateTime(2022, 10, 3, 8, 30),
    //   finishDate: DateTime(2022, 10, 12, 12, 30),
    //   activities: [],
    //   tokenReward: TokenReward(
    //     description: 'dsaadsdasads',
    //     image:
    //         'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2013%2F11%2F341164%2Cxcitefun-waterfalls-of-gods-iceland-1.jpg&f=1&nofb=1&ipt=5a5696c924ea46f3fc3a148fe5f1f06df5e59840c7380e38cde8215cbc3bbe66&ipo=images',
    //     name: 'asddadas',
    //     status: 'dasdasdas',
    //     tokenId: 'asdadsads',
    //     authorUrl: 'https://external-content.duckduckgo.com',
    //   ),
    //   owner: Account(),
    // )
  ];
  List<Challenge> _accountChallenges = [];

  bool isLoading = false;

  List<Challenge> get accountChallenges => _accountChallenges;

  ChallengesProvider({
    ChallengesService? service,
  }) : _service = service ?? ChallengesService(env: env);

  Future<List<Challenge>> load() async {
    isLoading = true;

    try {
      final qualificationList = await getChallenges();
      challenges = qualificationList.items;
    } catch (e) {
      print('Error loading active challenges $e');
    }

    isLoading = false;
    notifyListeners();

    return challenges;
  }

  Future<List<Challenge>> loadAccountChallenges() async {
    isLoading = true;

    try {
      final list = await _service.getAccountChallenges();
      _accountChallenges = list.items;
    } catch (e) {
      print('Error loading account challenges $e');
    }

    isLoading = false;
    notifyListeners();

    return _accountChallenges;
  }

  Future<ApiListResponse<Challenge>> getChallenges() {
    return _service.list(
      ChallengeSearchData(status: ChallengeStatus.OPEN),
    );
  }

  static ChallengesProvider of(context, {bool listen = true}) {
    return Provider.of<ChallengesProvider>(context, listen: listen);
  }

  static ChallengesProvider deaf(context) {
    return of(context, listen: false);
  }

  static ChangeNotifierProvider<ChallengesProvider> getProvider(
    ChallengesService service, [
    TransitionBuilder? builder,
  ]) {
    return ChangeNotifierProvider(
      create: (context) => ChallengesProvider(
        service: service,
      ),
      builder: builder,
    );
  }
}
