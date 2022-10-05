import 'package:rec_api_dart/rec_api_dart.dart';

extension ConfigurationSettingsAppExtension on ConfigurationSettings {
  static String badgeFiltersKey = 'map_badges_filter_status';
  static String c2bStatusKey = 'c2b_challenges_status';

  static String VALUE_ENABLED = 'enabled';
  static String VALUE_DISABLED = 'disabled';

  bool get badgeFiltersEnabled => settingsMap[badgeFiltersKey]?.value == VALUE_ENABLED;
  bool get c2bEnabled => settingsMap[c2bStatusKey]?.value == VALUE_ENABLED;
}
