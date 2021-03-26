import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Interfaces/ApiListResponse.dart';
import 'package:rec/Api/Services/ServiceBase.dart';
import 'package:rec/Entities/Transaction.ent.dart';

class TransactionsService extends ServiceBase {
  TransactionsService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  /// list all transactions, at an offset with a limit
  ///
  /// `offset` the page number
  /// `limit` the amount of items per page
  Future<ApiListResponse<Transaction>> list({int offset = 0, int limit = 10}) {
    final params = {'offset': '$offset', 'limit': '$limit'};
    final uri = ApiPaths.transactions.withQueryParams(params).toUri();

    return this.get(uri).then(_mapToApiListReponse);
  }

  // Maps api list reponse to an instance of ApiListResponse<Transaction>
  ApiListResponse<Transaction> _mapToApiListReponse(Map<String, dynamic> data) {
    return ApiListResponse<Transaction>.fromJson(
      data,
      mapper: (el) => Transaction.fromJson(el),
    );
  }
}
