import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/SelectableChip.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/activity_provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class MoreFiltersPage extends StatefulWidget {
  final Activity? selected;

  MoreFiltersPage({
    Key? key,
    this.selected,
  }) : super(key: key);

  @override
  _MoreFiltersPageState createState() => _MoreFiltersPageState();
}

class _MoreFiltersPageState extends State<MoreFiltersPage> {
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
    var activitiesLoading = _activityProvider!.activities!.isEmpty && _activityProvider!.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(context, title: 'MORE_CATEGORIES'),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: LocalizedText(
              'CULTURE',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
            ),
          ),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: activitiesLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildActivityList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    var locale = AppLocalizations.of(context)!.locale;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        children: _activityProvider!.activities!.map(
          (activity) {
            var isSelected = Activity.areEquals(widget.selected, activity);

            return SelectableChip(
              isSelected: isSelected,
              label: activity.getNameForLocale(locale) ?? '',
              onSelected: (selected) {
                selectActivity(selected ? activity : null);
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
