import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Interfaces/ApiListResponse.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Forms/CreateOfferData.dart';
import 'package:rec/Entities/Forms/UpdateOfferData.dart';
import 'package:rec/Entities/Offer.ent.dart';

/// This service is in charge of all requests related to [Offers]
/// Like listing, posting, updating, etc...
///
/// * **Authentication Required** - the user must be authenticated
class OffersService extends ServiceBase {
  OffersService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  /// List all [Offer] for the authenticated user
  Future<ApiListResponse<Offer>> list() {
    final uri = ApiPaths.offers.toUri();

    return this.get(uri).then(_mapOffers);
  }

  /// List all [Offer] for an account
  Future<ApiListResponse<Offer>> listFor({@required String accountId}) {
    final uri = ApiPaths.offers.toUri();

    return this.get(uri).then(_mapOffers);
  }

  /// Creates an offer linekd to the authenticated user's account.
  Future createOffer(CreateOfferData data) {
    final uri = ApiPaths.offers.toUri();

    return this.post(uri, data.toJson());
  }

  /// Update an offer instance
  Future updateOffer(String offerId, UpdateOfferData data) {
    final uri = ApiPaths.offers.append(offerId).toUri();

    return this.put(uri, data.toJson());
  }

  /// Delete an offer instance
  Future deleteOffer(String offerId) {
    final uri = ApiPaths.offers.append(offerId).toUri();

    return this.delete(uri);
  }

  ApiListResponse<Offer> _mapOffers(
    Map<String, dynamic> data,
  ) {
    return ApiListResponse.fromJson(
      {'elements': data['data']},
      mapper: (el) => Offer.fromJson(el),
    );
  }
}
