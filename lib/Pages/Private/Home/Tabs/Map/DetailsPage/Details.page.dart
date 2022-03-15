import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/BussinessHeader.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/DetailsPage/Offers.tab.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/DetailsPage/Schedule.tab.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/DetailsPage/Resume.tab.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class DetailsPage extends StatefulWidget {
  final Account? account;
  final ScrollController? scrollController;

  DetailsPage(this.account, {this.scrollController});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BussinessHeader(widget.account),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(child: LocalizedText('RESUME')),
              IgnorePointer(
                ignoring: widget.account!.offers == null || widget.account!.offers!.isEmpty,
                child: Tab(child: LocalizedText('OFFERS')),
              ),
              IgnorePointer(
                ignoring: widget.account!.schedule!.isNotAvailable,
                child: Tab(child: LocalizedText('SCHEDULE')),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ResumeTab(widget.account),
                OffersTab(
                  account: widget.account,
                  scrollController: widget.scrollController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 24,
                  ),
                  child: ScheduleTab(schedule: widget.account!.schedule),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
