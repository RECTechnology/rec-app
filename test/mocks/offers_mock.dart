import 'package:rec_api_dart/rec_api_dart.dart';


class OffersMock {
  static Offer priceOffer = Offer.fromJson({
    'type': 'rec',
    'description': 'Fresones variedad Fortuna/Inspire de calidad 1',
    'image': 'https://i.imgur.com/OzLV8hu.jpeg',
    'offer_price': 0.90,
  });

  static Offer percentOffer = Offer.fromJson({
    'type': 'percentage',
    'description': 'Lorem bla bla bla asjodjasd',
    'image': 'https://i.imgur.com/CSMrmgZ.jpeg',
    'discount': 10,
    'initial_price': 1,
    'offer_price': 0.90,
  });

  static Offer freeOffer = Offer.fromJson({
    'type': 'free',
    'description': 'Lorem bla bla bla asjodjasd',
    'image': 'https://images.unsplash.com/photo-1457567370786-91f841d5dad4',
  });
}
