import 'package:rec/Providers/Preferences/Preference.dart';
import 'package:rec/Providers/Preferences/PreferenceGroup.dart';

class PreferenceKeys {
  static const String showLtabCampaign = 'show_ltab_campaign';
  static const String showWalletBalance = 'show_wallet_balance';
}

class PreferenceDefinitions {
  static final Preference showLtabCampaign = Preference<bool>(
    defaultValue: true,
    storageKey: PreferenceKeys.showLtabCampaign,
    prettyName: 'SHOW_STAB',
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
      showWalletBalance,
    ],
  );

  static final List<Preference> all = [
    showLtabCampaign,
    showWalletBalance,
  ];
}
