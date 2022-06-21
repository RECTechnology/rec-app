import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

typedef BoolCallback = bool Function(BuildContext context);
typedef WidgetBuilderWithParams = Function(BuildContext context, Map<String, dynamic> data);

/// Defined certain logic for each campaign, like defining a builder for the
/// Participate page, or defining how each campaign checks if it's already participating or not.
class CampaignDefinition {
  /// Code that identifies the campaign
  String code;

  /// [WidgetBuilder] for the participation page of the given campaign
  WidgetBuilderWithParams participateBuilder;

  /// [WidgetBuilder] for the welcome page of the given campaign
  WidgetBuilderWithParams welcomeBuilder;

  /// [WidgetBuilder] for the extra data page of the given campaign
  WidgetBuilderWithParams? extraDataBuilder;

  /// [WidgetBuilder] for the box shown on recharge
  WidgetBuilderWithParams rechargeDescriptionBuilder;

  /// This funciond indicates whether the participate page should be opened initially
  /// It should be false, either if the user has marked the "don't show again"
  BoolCallback canBeOpened;

  /// This function should return whether the user is already participating or not
  BoolCallback hasAcceptedTOS;

  /// Function for accepting the terms of service for a given campaign

  CampaignDefinition({
    required this.code,
    required this.participateBuilder,
    required this.welcomeBuilder,
    required this.canBeOpened,
    required this.hasAcceptedTOS,
    required this.rechargeDescriptionBuilder,
    this.extraDataBuilder,
  });
}

/// Manager to handle actions and logic for campaigns, based on some definitions
class CampaignManager extends ChangeNotifier {
  final Map<String, CampaignDefinition> _definitions = {};

  String? activeCampaignCode;

  CampaignManager({
    List<CampaignDefinition> definitions = const [],
    this.activeCampaignCode,
  }) {
    for (var definition in definitions) {
      define(definition);
    }
  }

  CampaignManager define(CampaignDefinition definition) {
    _definitions[definition.code] = definition;

    return this;
  }

  CampaignDefinition? getDefinition(String? campaignCode) {
    if (campaignCode == null) return null;

    return _definitions[campaignCode];
  }

  bool hasDefinition(String campaignCode) {
    return _definitions.containsKey(campaignCode);
  }

  void setActiveCampaign(String code) {
    activeCampaignCode = code;
    notifyListeners();
  }

  static CampaignManager of(context, {bool listen = true}) {
    return Provider.of<CampaignManager>(
      context,
      listen: listen,
    );
  }

  static CampaignManager deaf(context) {
    return of(context, listen: false);
  }

  static ChangeNotifierProvider<CampaignManager> getProvider({
    List<CampaignDefinition> definitions = const [],
    String? activeCampaignCode,
  }) {
    return ChangeNotifierProvider(
      create: (context) => CampaignManager(
        definitions: definitions,
        activeCampaignCode: activeCampaignCode,
      ),
    );
  }
}
