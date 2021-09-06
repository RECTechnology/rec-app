import 'package:rec/Helpers/Checks.dart';

import 'Entity.base.dart';

enum OfferType {
  classic,
  percentage,
  free,
}

const offerTypesMap = {
  OfferType.classic: 'classic',
  OfferType.percentage: 'percentage',
  OfferType.free: 'free',
};

class Offer extends Entity {
  OfferType type;
  num initialPrice;
  num discountedPrice;
  num percentage;

  String description;
  String image;
  String endDate;

  bool get hasDiscount {
    return Checks.isNotNull(discountedPrice) || Checks.isNotNull(percentage);
  }

  bool get isFree => type == OfferType.free;
  bool get isPercent => type == OfferType.percentage;
  bool get isClassic => type == OfferType.classic;

  Offer({
    String id,
    String createdAt,
    String updatedAt,
    this.description,
    this.image,
    this.type = OfferType.classic,
    this.initialPrice,
    this.discountedPrice,
    this.percentage,
    this.endDate,
  }) : super(id, createdAt, updatedAt);

  Offer.empty()
      : description = '',
        image = null,
        type = OfferType.classic,
        initialPrice = null,
        discountedPrice = null,
        percentage = null,
        super('', '', '');

  factory Offer.fromJson(Map<String, dynamic> json) {
    var parsedDiscount = json['discount'] == null ? null : double.tryParse(json['discount']);

    var data = Offer(
      id: '${json['id']}',
      createdAt: json['created'],
      updatedAt: json['updated'],
      type: OfferType.values.firstWhere(
        (element) => element.toString().contains(json['type']),
        orElse: () => OfferType.classic,
      ),
      description: json['description'],
      image: json['image'],
      initialPrice: json['initial_price'],
      discountedPrice: json['offer_price'],
      percentage: parsedDiscount,
      endDate: json['end'],
    );

    return data;
  }
}
