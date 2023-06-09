import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/challenges/challenges_tab.dart';
import 'package:rec/Pages/Private/Home/Tabs/challenges/rewards_tab.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/mixins/loadable_mixin.dart';

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

    return WillPopScope(
      onWillPop: () async => true,
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
              Tab(child: LocalizedText('CHALLENGES', uppercase: true)),
              Tab(child: LocalizedText('REWARDS', uppercase: true)),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Theme(
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
