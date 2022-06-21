import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/BussinessHeader.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/details_page/offers.tab.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/details_page/schedule.tab.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/details_page/summary.tab.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class DetailsPage extends StatefulWidget {
  final Account account;
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
    final disableOfferTab = widget.account.offers == null || widget.account.offers!.isEmpty;
    final disableScheduleTab = widget.account.schedule!.isNotAvailable;

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
                ignoring: disableOfferTab,
                child: Tab(child: LocalizedText('OFFERS')),
              ),
              IgnorePointer(
                ignoring: disableScheduleTab,
                child: Tab(child: LocalizedText('SCHEDULE')),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SummaryTab(widget.account),
                OffersTab(
                  account: widget.account,
                  scrollController: widget.scrollController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 24,
                  ),
                  child: ScheduleTab(schedule: widget.account.schedule),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
