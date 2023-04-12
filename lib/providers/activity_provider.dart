import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ActivityGroup {
  final Activity parent;
  final List<Activity> children;

  ActivityGroup(this.parent, this.children);
}

class ActivityProvider extends ChangeNotifier {
  final ActivitiesService _service;
  List<Activity>? _activities = [];
  List<ActivityGroup> activityGroups = [];
  bool isLoading = false;

  List<Activity>? get activities => _activities;

  ActivityProvider({
    ActivitiesService? service,
  }) : _service = service ?? ActivitiesService(env: env);

  Future<List<Activity>> load([bool Function(Activity activity)? filter]) async {
    isLoading = true;

    var activitiesListResponse = await _service.list();
    _activities = activitiesListResponse.items;
    _activities!.sort((a, b) => a.name.compareTo(b.name));
    _createActivityGroups(_activities ?? []);

    if (filter != null) {
      _activities = _activities?.where(filter).toList();
    }

    isLoading = false;
    notifyListeners();

    return _activities ?? [];
  }

  Future<List<Activity>> loadOnly([bool Function(Activity activity)? filter]) async {
    var activitiesListResponse = await _service.list();
    _activities = activitiesListResponse.items;
    _activities!.sort((a, b) => a.name.compareTo(b.name));
    _createActivityGroups(_activities ?? []);

    if (filter != null) {
      _activities = _activities?.where(filter).toList();
    }

    return _activities ?? [];
  }

  void _createActivityGroups(List<Activity> activities) {
    final groups = <ActivityGroup>[];

    for (var act in activities) {
      if (act.hasParent) {
        // Find parent group and add activity to it
        final group = groups.firstWhere(
          (element) => element.parent.id == act.parentId,
          orElse: () => ActivityGroup(
            activities.firstWhere((element) => element.id == act.parentId),
            [],
          ),
        );
        group.children.add(act);
      }
      // If the activity has no parent, it means it's a parent
      else {
        groups.add(
          ActivityGroup(
            act,
            [act],
          ),
        );
      }
    }

    activityGroups = groups;
  }

  static ActivityProvider of(context, {bool listen = true}) {
    return Provider.of<ActivityProvider>(
      context,
      listen: listen,
    );
  }

  static ActivityProvider deaf(context) {
    return of(context, listen: false);
  }

  static ChangeNotifierProvider<ActivityProvider> getProvider(
    ActivitiesService service,
  ) {
    return ChangeNotifierProvider(
      create: (context) => ActivityProvider(
        service: service,
      ),
    );
  }
}
