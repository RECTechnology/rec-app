import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/providers/preferences/Preference.dart';

class PreferenceGroup {
  final Map<String, Preference> preferences = {};
  String name;

  PreferenceGroup(
    this.name, {
    List<Preference> preferences = const [],
  }) {
    for (var element in preferences) {
      addPreference(element);
    }
  }

  void addPreference(Preference preference) {
    preferences[preference.storageKey] = preference;
  }

  Preference? getPreference(String key) {
    return preferences[key];
  }

  List<Preference> getPreferences() {
    return List.from(preferences.values);
  }

  dynamic get(String key) {
    var pref = getPreference(key);
    return Checks.isNotNull(pref) ? pref!.value : null;
  }

  Future<bool?> set(String key, dynamic value) async {
    if (preferences[key] == null) {
      preferences[key] = Preference(storageKey: key, value: value);
    }
    return preferences[key]!.set(value);
  }
}
