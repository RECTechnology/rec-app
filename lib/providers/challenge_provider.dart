import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ChallengesProvider extends ChangeNotifier {
  final ChallengesService _service;

  List<Challenge> challenges = [];
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
