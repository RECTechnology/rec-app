import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Interfaces/ApiListResponse.dart';
import 'package:rec/Api/Services/ServiceBase.dart';
import 'package:rec/Entities/CreditCard.dart';

class CardsService extends ServiceBase {
  CardsService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  /// list all Cards for current account, at an offset with a limit
  Future<ApiListResponse<CreditCard>> list() {
    final uri = ApiPaths.listCards.toUri();
    return this.get(uri).then(_mapToApiListReponse);
  }

  ApiListResponse<CreditCard> _mapToApiListReponse(Map<String, dynamic> data) {
    return ApiListResponse<CreditCard>.fromJson(
      {
        'elements': data['data'],
        'total': data['data'].length,
      },
      mapper: (el) => CreditCard.fromJson(el),
    );
  }
}
