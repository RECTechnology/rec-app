import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class BadgeGroup {
  final String group;
  final String groupEs;
  final String groupCa;

  List<Badge> badges = [];

  BadgeGroup({
    required this.group,
    required this.groupEs,
    required this.groupCa,
    List<Badge>? badges,
  }) : badges = badges ?? [];

  /// Returns the [name] for the current locale, if locale is not handled it will return [name]
  String getNameForLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return groupEs;
      case 'ca':
        return groupCa;
      case 'en':
      default:
        return group;
    }
  }
}

class BadgesProvider extends ChangeNotifier {
  final BadgesService _service;

  List<Badge> _badges = [];
  List<BadgeGroup> _badgesByGroup = [];

  bool isLoading = false;

  List<Badge> get badges => _badges;
  List<BadgeGroup> get badgesByGroup => _badgesByGroup;

  BadgesProvider({BadgesService? service}) : _service = service ?? BadgesService(env: env);

  Future<void> loadByGroup() async {
    isLoading = true;

    _badges = (await _service.list({})).items as List<Badge>;
    _badgesByGroup = [];

    final Map<String, BadgeGroup> badgesByGroup = {};

    for (final badge in _badges) {
      final badgeInMap = badgesByGroup.containsKey(badge.group);

      if (!badgeInMap) {
        badgesByGroup[badge.group] = BadgeGroup(
          group: badge.group,
          groupEs: badge.groupEs,
          groupCa: badge.groupCa,
        );
      }

      badgesByGroup[badge.group]?.badges.add(badge);
    }

    _badgesByGroup = badgesByGroup.values.toList();

    isLoading = false;
    notifyListeners();
  }

  static BadgesProvider of(context, {bool listen = true}) {
    return Provider.of<BadgesProvider>(
      context,
      listen: listen,
    );
  }

  static BadgesProvider deaf(context) => of(context, listen: false);

  static ChangeNotifierProvider<BadgesProvider> getProvider(
    BadgesService service,
  ) {
    return ChangeNotifierProvider(
      create: (_) => BadgesProvider(service: service),
    );
  }
}
