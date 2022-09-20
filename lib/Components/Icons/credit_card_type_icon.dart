import 'package:flutter/material.dart';
import 'package:rec/config/asset_theme.dart';
import 'package:rec/config/theme.dart';

enum CreditCardType {
  VISA,
  MASTERCARD,
  AMERICAN_EXPRESS,
  UKNOWN,
}

extension CreditCardTypeName on CreditCardType {
  String? getAssetFromTheme(RecAssetTheme assets) {
    switch (this) {
      case CreditCardType.VISA:
        return assets.cardVisa;
      case CreditCardType.MASTERCARD:
        return assets.cardMastercard;
      case CreditCardType.AMERICAN_EXPRESS:
        break;
      case CreditCardType.UKNOWN:
        break;
    }

    return null;
  }
}

class CreditCardTypeIcon extends StatelessWidget {
  final String alias;
  final double size;
  final Color? color;

  const CreditCardTypeIcon({
    Key? key,
    required this.alias,
    this.size = 32,
    this.color,
  }) : super(key: key);

  CreditCardType get cardType {
    if (alias[0] == '3') return CreditCardType.AMERICAN_EXPRESS;
    if (alias[0] == '4') return CreditCardType.VISA;
    if (alias[0] == '5') return CreditCardType.MASTERCARD;

    return CreditCardType.UKNOWN;
  }

  Widget getCardTypeAsset(RecAssetTheme assets) {
    final asset = cardType.getAssetFromTheme(assets);

    if (asset != null) {
      return Image.asset(
        asset,
        width: size,
      );
    }

    return Icon(
      Icons.credit_card,
      size: size,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final assets = RecTheme.of(context)!.assets;
    return getCardTypeAsset(assets);
  }
}
