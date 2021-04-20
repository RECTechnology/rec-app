import 'package:rec/Entities/CreditCard.dart';
import 'package:rec/Entities/Forms/FormData.dart';

class RechargeData extends FormData {
  double amount = 0;
  CreditCard card;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
