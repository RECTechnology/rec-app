import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RewardsProvider extends ChangeNotifier {
  final TokenRewardsService _service;

  List<TokenReward>? _pendingRewards = [
    TokenReward(
      description: 'dsaadsdasads',
      image:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2013%2F11%2F341164%2Cxcitefun-waterfalls-of-gods-iceland-1.jpg&f=1&nofb=1&ipt=5a5696c924ea46f3fc3a148fe5f1f06df5e59840c7380e38cde8215cbc3bbe66&ipo=images',
      name: 'Gasta 10R en tiendas que vendan productos ecológicos ',
      status: 'dasdasdas',
      tokenId: 'asdadsads',
    ),
    TokenReward(
      description: 'dsaadsdasads',
      image:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2013%2F11%2F341164%2Cxcitefun-waterfalls-of-gods-iceland-1.jpg&f=1&nofb=1&ipt=5a5696c924ea46f3fc3a148fe5f1f06df5e59840c7380e38cde8215cbc3bbe66&ipo=images',
      name: 'Realiza 2 compras en tiendas que vendan producto a granel',
      status: 'dasdasdas',
      tokenId: 'asdadsads',
    ),
    TokenReward(
      description: 'dsaadsdasads',
      image:
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.xcitefun.net%2Fusers%2F2013%2F11%2F341164%2Cxcitefun-waterfalls-of-gods-iceland-1.jpg&f=1&nofb=1&ipt=5a5696c924ea46f3fc3a148fe5f1f06df5e59840c7380e38cde8215cbc3bbe66&ipo=images',
      name: 'Envía 5 RECs a un amigo',
      status: 'dasdasdas',
      tokenId: 'asdadsads',
    ),
  ];
  bool isLoading = false;

  List<TokenReward>? get pendingRewards => _pendingRewards;

  RewardsProvider({
    TokenRewardsService? service,
  }) : _service = service ?? TokenRewardsService(env: env);

  Future<List<TokenReward>> loadPending() async {
    isLoading = true;

    // final qualificationList = await getRewards();
    await Future.delayed(Duration(seconds: 4));
    // _pendingRewards = qualificationList.items;

    isLoading = false;
    notifyListeners();

    return _pendingRewards ?? [];
  }

  Future<ApiListResponse<TokenReward>> getRewards() {
    return _service.list();
  }

  // Future<dynamic> updateTokenReward(String id, UpdateTokenRewardData data) {
  //   return _service.updateTokenReward(id, data);
  // }

  static RewardsProvider of(context, {bool listen = true}) {
    return Provider.of<RewardsProvider>(context, listen: listen);
  }

  static RewardsProvider deaf(context) {
    return of(context, listen: false);
  }

  static ChangeNotifierProvider<RewardsProvider> getProvider(
    TokenRewardsService service, [
    TransitionBuilder? builder,
  ]) {
    return ChangeNotifierProvider(
      create: (context) => RewardsProvider(
        service: service,
      ),
      builder: builder,
    );
  }
}
