import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Interfaces/ApiListResponse.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Map/MapSearchData.dart';

/// used to perform actions on accounts
class AccountsService extends ServiceBase {
  AccountsService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  /// Used to get an account by it's [id]
  Future<Account> getOne(String id) async {
    var path = ApiPaths.accounts.withId(id).toUri();

    return this.get(path).then(_mapToObject);
  }

  Future<ApiListResponse<Account>> search(MapSearchData searchData) async {
    var pathWithParams = ApiPaths.accountsSearch.withQueryParams({
      'offset': searchData.offset.toString(),
      'limit': searchData.limit.toString(),
      'sort': searchData.sort.toString(),
      'order': searchData.order.toString(),
      'search': searchData.search.toString(),
      'only_with_offers': '${searchData.onlyWithOffers ? 1 : 0}',
      'type': searchData.type.toString(),
      'subtype': searchData.subType.toString(),
    }).toUri();

    return this.get(pathWithParams).then(_mapToApiListReponse);
  }

  ApiListResponse<Account> _mapToApiListReponse(Map<String, dynamic> data) {
    return ApiListResponse<Account>.fromJson(
      data['data'],
      mapper: (el) => Account.fromJson(el),
    );
  }

  Account _mapToObject(Map<String, dynamic> data) =>
      Account.fromJson(data['data']);
}
