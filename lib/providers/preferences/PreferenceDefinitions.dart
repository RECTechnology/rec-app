import 'package:rec/providers/preferences/Preference.dart';
import 'package:rec/providers/preferences/PreferenceGroup.dart';

class PreferenceKeys {
  static const String showLtabCampaign = 'show_LTAB20';
  static const String showCultureCampaign = 'show_CULT21';
  static const String showWalletBalance = 'show_wallet_balance';
}

class PreferenceDefinitions {
  static final Preference showLtabCampaign = Preference<bool>(
    defaultValue: true,
    storageKey: PreferenceKeys.showLtabCampaign,
    prettyName: 'SHOW_LTAB',
    type: PreferenceType.checkbox,
  );

  static final Preference showCultureCampaign = Preference<bool>(
    defaultValue: true,
    storageKey: PreferenceKeys.showCultureCampaign,
    prettyName: 'SHOW_CULT',
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
    ],
  );

  static final List<Preference> all = [
    showLtabCampaign,
    showCultureCampaign,
    showWalletBalance,
  ];
}
