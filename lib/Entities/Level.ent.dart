import 'package:rec/Helpers/Checks.dart';

/// Class containing information about an account KYC Level
class Level {
  static final String CODE_KYC1 = 'KYC1';
  static final String CODE_KYC2 = 'KYC2';
  static final String CODE_KYC3 = 'KYC3';

  /// The level's identifier
  final int id;

  /// The level's code. ie. KYC1, KYC3
  final String code;

  /// Description about what this level allows
  final String description;

  /// Parent level, can be null
  /// A parent is a role whith more hierarchy that itself,
  /// so it allows more things
  final Level parent;

  /// List of Levels that are hierarchically below itself,
  /// meaning they can do less that itself
  final List<Level> children;

  // Maximun amount of RECs this level allows to be sent
  final num maxOut;

  Level({
    this.id,
    this.code = '',
    this.description = '',
    this.parent,
    this.children = const [],
    this.maxOut = 0,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    var children = <Level>[];

    if (json['children'] != null) {
      var levelKinds = List.from(json['children']);
      children = levelKinds.isNotEmpty
          ? levelKinds.map<Level>((el) => Level.fromJson(el)).toList()
          : <Level>[];
    }

    return Level(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      children: children,
      parent: Checks.isNotEmpty(json['parent'])
          ? Level.fromJson(json['parent'])
          : null,
      maxOut: json['max_out'],
    );
  }
}
