import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RewardsProvider extends ChangeNotifier {
  final TokenRewardsService _service;

  final List<TokenReward>? _pendingRewards = [];
  bool isLoading = false;

  List<TokenReward>? get pendingRewards => _pendingRewards;

  RewardsProvider({
    TokenRewardsService? service,
  }) : _service = service ?? TokenRewardsService(env: env);

  Future<List<TokenReward>> load() async {
    isLoading = true;

    // final qualificationList = await getRewards();
    await Future.delayed(Duration(seconds: 4));
    // _pendingRewards = qualificationList.items;

    isLoading = false;
    notifyListeners();

    return _pendingRewards ?? [];
  }

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
