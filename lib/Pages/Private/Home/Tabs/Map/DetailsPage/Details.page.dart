import 'package:flutter/material.dart';
import 'package:rec/Components/Map/BussinessHeader.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/DetailsPage/ScheduleListTab.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/DetailsPage/ResumeTab.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class DetailsPage extends StatefulWidget {
  final Account account;

  DetailsPage(this.account);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  List<String> days = [];
  bool isResume = true;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: BussinessHeader(widget.account),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Brand.primaryColor,
            indicatorColor: Brand.primaryColor,
            unselectedLabelColor: Brand.grayDark4,
            isScrollable: true,
            tabs: [
              Tab(
                child: Text(localizations.translate('RESUME')),
              ),
              Tab(
                child: Text(localizations.translate('SCHEDULE')),
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
