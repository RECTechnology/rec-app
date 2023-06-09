import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/providers/preferences/Preference.dart';
import 'package:rec/providers/preferences/PreferenceGroup.dart';


class PreferenceProvider extends PreferenceGroup with ChangeNotifier {
  final Map<String, PreferenceGroup> _preferenceGroups = {};

  PreferenceProvider({
    List<Preference> preferences = const [],
    List<PreferenceGroup> groups = const [],
  }) : super('default', preferences: preferences) {
    for (var element in groups) {
      addPreferenceGroup(element);
    }
  }

  int get groupCount => _preferenceGroups.values.length;

  void addPreferenceGroup(PreferenceGroup group) {
    _preferenceGroups[group.name] = group;
  }

  PreferenceGroup? getPreferenceGroup(String key) {
    return _preferenceGroups[key];
  }

  List<PreferenceGroup> getPreferenceGroups() {
    return List.from(_preferenceGroups.values);
  }

  @override
  Future<bool?> set(String key, dynamic value) async {
    await super.set(key, value);
    notifyListeners();
    return value;
  }

  static PreferenceProvider of(context, {bool listen = true}) {
    return Provider.of<PreferenceProvider>(context, listen: listen);
  }

  static PreferenceProvider deaf(context) {
    return Provider.of<PreferenceProvider>(context, listen: false);
  }

  static ChangeNotifierProvider<PreferenceProvider> getProvider({
    List<Preference> preferences = const [],
    List<PreferenceGroup> groups = const [],
  }) {
    var provider = PreferenceProvider(
      preferences: preferences,
      groups: groups,
    );

    return ChangeNotifierProvider(
      create: (context) => provider,
    );
  }
}
