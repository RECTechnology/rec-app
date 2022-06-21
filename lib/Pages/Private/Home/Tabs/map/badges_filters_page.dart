import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/SelectableChip.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/filter_group_list.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/badges_provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class BadgesFiltersPage extends StatefulWidget {
  final Badge? selected;

  BadgesFiltersPage({Key? key, this.selected}) : super(key: key);

  @override
  _BadgesFiltersPageState createState() => _BadgesFiltersPageState();
}

class _BadgesFiltersPageState extends State<BadgesFiltersPage> {
  BadgesProvider? _provider;
  get isLoading => _provider!.badgesByGroup.isEmpty && _provider!.isLoading;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_provider == null) {
      _provider = BadgesProvider.of(context);
      _provider!.loadByGroup();
    }
  }

  void selectFilter(Badge? badge) {
    Navigator.pop(context, badge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(
        context,
        title: 'BADGES',
        backAction: () {
          selectFilter(widget.selected);
        },
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return _buildFilterGroups(context);
  }

  Widget _buildFilterGroups(BuildContext context) {
    final badgeGroups = _provider?.badgesByGroup ?? <BadgeGroup>[];

    if (badgeGroups.isEmpty) {
      return Center(
        child: LocalizedText('NO_FILTERS'),
      );
    }

    final List<Widget> groupWidgets = [];
    final locale = AppLocalizations.of(context)!.locale;

    // Create a FilterGroupList for each group
    for (final group in badgeGroups) {
      groupWidgets.add(
        FilterGroupList(
          isLoading: false, // Always false, as the loading is handled in [build]
          itemCount: group.badges.length,
          title: Text(
            group.getNameForLocale(locale),
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
          ),
          itemBuilder: (_, index) => _buildFilterChip(group.badges[index]),
          loadingBuilder: (_) => Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groupWidgets,
      ),
    );
  }

  Widget _buildFilterChip(Badge? badge) {
    final locale = AppLocalizations.of(context)!.locale;

    // If for some reason, badge is null, just return a shrinked SizedBox
    if (badge == null) {
      return SizedBox.shrink();
    }

    final isSelected = widget.selected != null && badge.id == widget.selected!.id;

    return SelectableChip(
      isSelected: isSelected,
      label: badge.getNameForLocale(locale),
      onSelected: (selected) {
        selectFilter(selected ? badge : null);
      },
    );
  }
}
