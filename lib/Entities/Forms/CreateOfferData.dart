import 'package:rec/Entities/Forms/FormData.dart';
import 'package:rec/Entities/Offer.ent.dart';
import 'package:rec/Helpers/Checks.dart';

class CreateOfferData extends FormData {
  OfferType type = OfferType.classic;
  String description;
  String image;
  String end;
  num initialPrice;
  num offerPrice;
  num discount;

  CreateOfferData();

  bool get isValid => Checks.isNotNull(type) && Checks.isNotNull(end);

  @override
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'end': end,
      'type': offerTypesMap[type],
      'initial_price': initialPrice,
      'offer_price': offerPrice,
      'discount': discount,
      'image': image,
    };
  }
}
