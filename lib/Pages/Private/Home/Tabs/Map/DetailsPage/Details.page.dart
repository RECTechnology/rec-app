import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/BussinessHeader.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/DetailsPage/ScheduleListTab.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/DetailsPage/ResumeTab.dart';

class DetailsPage extends StatefulWidget {
  final Account account;

  DetailsPage(this.account);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
              Tab(
                child: LocalizedText('RESUME'),
              ),
              IgnorePointer(
                ignoring: widget.account.schedule.isNotAvailable,
                child: Tab(child: LocalizedText('SCHEDULE')),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ResumeTab(widget.account),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 24,
                  ),
                  child: ScheduleListTab(schedule: widget.account.schedule),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
