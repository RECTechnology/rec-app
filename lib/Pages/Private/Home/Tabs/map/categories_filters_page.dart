import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/SelectableChip.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/filter_group_list.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_activityProvider == null) {
      _activityProvider = ActivityProvider.of(context);
      _activityProvider!.load();
    }
  }

  void selectActivity(Activity? activity) {
    Navigator.pop(context, activity);
  }

  @override
  Widget build(BuildContext context) {
    final activities = _activityProvider!.activities ?? [];
    final activitiesLoading = activities.isEmpty && _activityProvider!.isLoading;
    final itemCount = activities.length;

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
        child: FilterGroupList(
          isLoading: activitiesLoading,
          itemCount: itemCount,
          title: LocalizedText(
            'CULTURE',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
          ),
          itemBuilder: (_, index) => _buildFilterChip(index),
          loadingBuilder: (_) => Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(int index) {
    final locale = AppLocalizations.of(context)!.locale;
    final activity = _activityProvider?.activities?[index];
    final isSelected = Activity.areEquals(widget.selected, activity);

    // If for some reason, badge is null, just return a shrinked SizedBox
    if (activity == null) {
      return SizedBox.shrink();
    }

    return SelectableChip(
      isSelected: isSelected,
      label: activity.getNameForLocale(locale) ?? '',
      onSelected: (selected) {
        selectActivity(selected ? activity : null);
      },
    );
  }
}
