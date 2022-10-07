import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/challenges/challenges_tab.dart';
import 'package:rec/Pages/Private/Home/Tabs/challenges/rewards_tab.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/mixins/loadable_mixin.dart';
import 'package:rec/providers/challenge_provider.dart';
import 'package:rec/providers/reward_provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ChallengesPage extends StatefulWidget {
  ChallengesPage({Key? key}) : super(key: key);

  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage>
    with StateLoading, SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
   
    return MultiProvider(
      providers: [
        ChallengesProvider.getProvider(ChallengesService(env: env)),
        RewardsProvider.getProvider(TokenRewardsService(env: env))
      ],
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PrivateAppBar(
            size: 60,
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.8),
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: LocalizedText('CHALLENGES')),
                Tab(child: LocalizedText('REWARDS')),
              ],
            ),
          ),
          body: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSwatch().copyWith(secondary: recTheme!.primaryColor),
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                ChallengesTab(),
                RewardsTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
