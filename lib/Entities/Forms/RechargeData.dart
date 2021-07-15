import 'package:rec/Entities/Forms/FormData.dart';

class RechargeData extends FormData {
  double amount = 0;
  String commerceId;
  String concept;
  String pin;

  bool campaignTermsAccepted = true;
  bool willEnterCampaign = false;

  @override
  Map<String, dynamic> toJson() {
    return {
      'commerce_id': '$commerceId',
      'amount': amount * 100,
      'concept': concept ?? 'recarga',
      'save_card': false,
      'pin': '$pin',
    };
  }
}
