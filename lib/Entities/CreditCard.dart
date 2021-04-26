import 'package:flutter/material.dart';
import 'package:rec/Entities/Entity.base.dart';

class CreditCard extends Entity {
  static String TYPE_VISA = 'VISA';
  static String TYPE_MC = 'MASTERCARD';
  static String TYPE_AE = 'AMERICAN_EXPRESS';
  static String TYPE_DISCOVER = 'DISCOVER';
  static String TYPE_UKNOWN = 'UKNOWN';

  String alias;
  bool deleted;

  CreditCard({
    String id,
    String createdAt,
    String updatedAt,
    this.alias,
    this.deleted,
  }) : super(id, createdAt, updatedAt);

  /// Returns a formatted version of the alias
  String get formattedAlias {
    var regexp = RegExp(r'[0-9a-z]{4}', caseSensitive: false);
    var matches = regexp.allMatches(alias).map(
          (match) => match.group(0),
        );

    return matches.join(' ');
  }

  String get cardType {
    if (alias[0] == '3') return CreditCard.TYPE_AE;
    if (alias[0] == '4') return CreditCard.TYPE_VISA;
    if (alias[0] == '5') return CreditCard.TYPE_MC;

    return CreditCard.TYPE_UKNOWN;
  }

  Widget get cardTypeAsset {
    if (cardType == CreditCard.TYPE_VISA || cardType == CreditCard.TYPE_MC) {
      return Image.asset(
        'assets/credit-cards/${cardType.toLowerCase()}.png',
        width: 40,
      );
    }

    return Icon(
      Icons.credit_card,
      size: 40,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: '${json['id']}',
      createdAt: json['created'],
      updatedAt: json['updated'],
      alias: json['alias'],
      deleted: json['deleted'],
    );
  }
}
