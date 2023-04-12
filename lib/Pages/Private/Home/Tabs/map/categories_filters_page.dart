import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/SelectableChip.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/filter_group_list.dart';
import 'package:rec/config/features.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/providers/activity_provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CategoriesFiltersPage extends StatefulWidget {
  final Activity? selected;

  CategoriesFiltersPage({
    Key? key,
    this.selected,
  }) : super(key: key);

  @override
  _CategoriesFiltersPageState createState() => _CategoriesFiltersPageState();
}

class _CategoriesFiltersPageState extends State<CategoriesFiltersPage> {
  ActivityProvider? _activityProvider;
  final _ignoredActivities = [Features.cultureActivityName];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_activityProvider == null) {
      _activityProvider = ActivityProvider.of(context);
      _activityProvider!.load((activity) {
        return _ignoredActivities.contains(activity.name) == false;
      });
    }
  }

  void selectActivity(Activity? activity) {
    Navigator.pop(context, activity);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final locale = localizations!.locale;
    final groups = _activityProvider?.activityGroups ?? [];
    groups.sort((a, b) {
      final aName = a.parent.getNameForLocale(locale) ?? a.parent.name;
      final bName = b.parent.getNameForLocale(locale) ?? b.parent.name;

      return aName.compareTo(bName);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(
        context,
        title: 'MORE_CATEGORIES',
        backAction: () {
          selectActivity(widget.selected);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var group in groups) _buildGroup(group),
          ],
        ),
      ),
    );
  }

  _buildGroup(ActivityGroup group) {
    final localizations = AppLocalizations.of(context);
    return FilterGroupList(
      isLoading: false,
      itemCount: group.children.length,
      title: LocalizedText(
        group.parent.getNameForLocale(localizations!.locale) ?? group.parent.name,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
      ),
      itemBuilder: (_, index) => _buildFilterChip(group, index),
      loadingBuilder: (_) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildFilterChip(ActivityGroup group, int index) {
    final locale = AppLocalizations.of(context)!.locale;
    final activity = group.children[index];
    final isSelected = Activity.areEquals(widget.selected, activity);

    return SelectableChip(
      isSelected: isSelected,
      label: activity.getNameForLocale(locale) ?? '',
      onSelected: (selected) {
        selectActivity(selected ? activity : null);
      },
    );
  }
}
