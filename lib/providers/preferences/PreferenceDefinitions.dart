import 'package:rec/providers/preferences/Preference.dart';
import 'package:rec/providers/preferences/PreferenceGroup.dart';

class PreferenceKeys {
  static const String showLtabCampaign = 'show_LTAB20';
  static const String showCultureCampaign = 'show_CULT21';
  static const String showCultureThresholdReached = 'show_CULT21_threshold';
  static const String showWalletBalance = 'show_wallet_balance';
  static const String showGenericThresholdReached = 'show_threshold';
  static const String showGenericCampaign = 'show_generic';
}

class PreferenceDefinitions {
  static final Preference showLtabCampaign = Preference<bool>(
    defaultValue: true,
    storageKey: PreferenceKeys.showLtabCampaign,
    prettyName: 'SHOW_LTAB',
    type: PreferenceType.checkbox,
  );

  static final Preference showGenericCampaign = Preference<bool>(
    defaultValue: true,
    storageKey: PreferenceKeys.showGenericCampaign,
    prettyName: 'SHOW_GENERIC',
    type: PreferenceType.checkbox,
  );

  static final Preference showGenericThresholdReached = Preference<bool>(
    defaultValue: true,
    storageKey: PreferenceKeys.showGenericCampaign,
    prettyName: 'SHOW_GENERIC_THRESHOLD',
    type: PreferenceType.checkbox,
  );

  static final Preference showCultureCampaign = Preference<bool>(
    defaultValue: true,
    storageKey: PreferenceKeys.showCultureCampaign,
    prettyName: 'SHOW_CULT',
    type: PreferenceType.checkbox,
  );

  static final Preference showCultureThresholdReached = Preference<bool>(
    defaultValue: true,
    storageKey: PreferenceKeys.showCultureThresholdReached,
    prettyName: 'SHOW_CULT_THRESHOLD_REACHED',
    type: PreferenceType.checkbox,
  );

  static final Preference showWalletBalance = Preference<bool>(
    defaultValue: true,
    storageKey: PreferenceKeys.showWalletBalance,
    prettyName: 'SHOW_BALANCE',
    type: PreferenceType.checkbox,
  );

  static final PreferenceGroup general = PreferenceGroup(
    'general',
    preferences: [
      showLtabCampaign,
      showCultureCampaign,
      showWalletBalance,
      showCultureThresholdReached,
      showGenericCampaign,
    ],
  );

  static final List<Preference> all = [
    showLtabCampaign,
    showCultureCampaign,
    showWalletBalance,
    showCultureThresholdReached,
    showGenericCampaign,
  ];
}
