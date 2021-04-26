import 'package:rec/Entities/CreditCard.dart';
import 'package:rec/Entities/Forms/FormData.dart';

class RechargeData extends FormData {
  double amount = 0;
  String commerceId;
  String concept;
  String pin;

  bool saveCard;

  CreditCard card;

  @override
  Map<String, dynamic> toJson() {
    if (card == null) {
      return {
        'commerce_id': '$commerceId',
        'amount': amount * 100,
        'concept': concept ?? 'recarga',
        'save_card': saveCard,
        'pin': '$pin',
      };
    } else {
      return {
        'commerce_id': '$commerceId',
        'amount': amount * 100,
        'concept': concept ?? 'recarga',
        'card_id': '${card.id}',
        'save_card': 'false',
        'pin': '$pin',
      };
    }
  }
}
