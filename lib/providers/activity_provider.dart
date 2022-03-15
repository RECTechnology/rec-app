import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivitiesService _service;
  List<Activity>? _activities = [];
  bool isLoading = false;

  List<Activity>? get activities => _activities;

  ActivityProvider({
    ActivitiesService? service,
  }) : _service = service ?? ActivitiesService(env: env);

  Future<void> load() async {
    isLoading = true;

    var activitiesListResponse = await _service.list();
    _activities = activitiesListResponse.items;
    _activities!.sort((a, b) => a.name!.compareTo(b.name!));

    isLoading = false;
    notifyListeners();
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
