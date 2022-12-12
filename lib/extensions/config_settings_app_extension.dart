import 'package:rec_api_dart/rec_api_dart.dart';

import '../environments/env.dart';

extension ConfigurationSettingsAppExtension on ConfigurationSettings {
  static String badgeFiltersKey = 'map_badges_filter_status';
  static String c2bStatusKey = 'c2b_challenges_status';
  static String mapLatKey = 'map_init_lat';
  static String mapLonKey = 'map_init_lon';
  static String mapZoomKey = 'map_init_zoom';

  static String VALUE_ENABLED = 'enabled';
  static String VALUE_DISABLED = 'disabled';

  bool get badgeFiltersEnabled => settingsMap[badgeFiltersKey]?.value == VALUE_ENABLED;
  bool get c2bEnabled => settingsMap[c2bStatusKey]?.value == VALUE_ENABLED;

  double get mapLat => double.tryParse(settingsMap[mapLatKey]?.value ?? '') ?? env.MAP_CENTER_LAT;
  double get mapLon => double.tryParse(settingsMap[mapLonKey]?.value ?? '') ?? env.MAP_CENTER_LON;
  double get mapZoom => double.tryParse(settingsMap[mapZoomKey]?.value ?? '') ?? env.MAP_ZOOM;
}
