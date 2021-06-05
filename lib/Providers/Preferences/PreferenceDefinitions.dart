import 'package:rec/Providers/Preferences/Preference.dart';
import 'package:rec/Providers/Preferences/PreferenceGroup.dart';

class PreferenceKeys {
  static const String showLtabCampaign = 'show_ltab_campaign';
}

class PreferenceDefinitions {
  static final Preference showLtabCampaign = Preference<bool>(
    defaultValue: true,
    storageKey: PreferenceKeys.showLtabCampaign,
    prettyName: 'SHOW_STAB',
    type: PreferenceType.checkbox,
  );

  static final PreferenceGroup general = PreferenceGroup(
    'general',
    preferences: [showLtabCampaign],
  );

  static final List<Preference> all = [
    showLtabCampaign,
  ];
}
