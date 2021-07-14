import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Providers/Preferences/Preference.dart';

class PreferenceGroup {
  final Map<String, Preference> _preferences = {};
  String name;

  PreferenceGroup(
    this.name, {
    List<Preference> preferences = const [],
  }) {
    preferences.forEach((element) {
      addPreference(element);
    });
  }

  void addPreference(Preference preference) {
    _preferences[preference.storageKey] = preference;
  }

  Preference getPreference(String key) {
    return _preferences[key];
  }

  List<Preference> getPreferences() {
    return List.from(_preferences.values);
  }

  dynamic get(String key) {
    var pref = getPreference(key);
    return Checks.isNotNull(pref) ? pref.value : null;
  }

  dynamic set(String key, dynamic value) {
    _preferences[key].set(value);
    return value;
  }
}
