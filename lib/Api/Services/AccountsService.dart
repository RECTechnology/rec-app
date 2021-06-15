import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Interfaces/ApiListResponse.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/AccountPermission.ent.dart';
import 'package:rec/Entities/Forms/CreatePermissionData.dart';
import 'package:rec/Entities/Forms/NewAccountData.dart';
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
    var path = ApiPaths.accounts.append(id).toUri();

    return this.get(path).then(_mapToObject);
  }

  Future<ApiListResponse<Account>> search(MapSearchData searchData) async {
    var data = {
      'offset': searchData.offset.toString(),
      'limit': searchData.limit.toString(),
      'sort': searchData.sort.toString(),
      'order': searchData.order.toString(),
      'search': searchData.search.toString(),
      'only_with_offers': '${searchData.onlyWithOffers ? 1 : 0}',
      'type': searchData.type.toString(),
      'subtype': searchData.subType.toString(),
    };
    if (searchData.campaign != null && searchData.campaign.isNotEmpty) {
      data['campaigns'] = searchData.campaign;
    }

    var pathWithParams = ApiPaths.accountsSearch.withQueryParams(data).toUri();

    return this.get(pathWithParams).then(_mapToApiListReponse);
  }

  Future addUserToAccount(String accountId, CreatePermissionData data) {
    var path = ApiPaths.accountsAddUser.append(accountId).toUri();

    return this.post(path, {
      'user_dni': data.dni,
      'role': data.role,
    });
  }

  Future updateUserInAccount(String accountId, int permissionId, String role) {
    var path = ApiPaths.accountsEditRole.appendMultiple([
      accountId,
      permissionId.toString(),
    ]).toUri();
    return this.post(path, {'role': role});
  }

  Future deleteUserFromAccount(String accountId, int permissionId) {
    var path = ApiPaths.accountsAddUser
        .appendMultiple([accountId, permissionId.toString()]).toUri();

    return this.delete(path);
  }

  /// Creates a new account linked to the authenticated user
  Future addAccount(NewAccountData data) {
    var path = ApiPaths.accountsAddNew.toUri();

    return this.post(path, data.toJson());
  }

  Future updateAccount(String accountId, Map<String, dynamic> data) {
    var path = ApiPaths.accounts.append(accountId).toUri();

    return this.put(path, data);
  }

  Future<ApiListResponse<AccountPermission>> listAccountPermissions(
    String accountId,
  ) {
    var path = ApiPaths.accountsPermissions.append(accountId).toUri();

    return this.get(path).then(_mapPermissions);
  }

  ApiListResponse<Account> _mapToApiListReponse(Map<String, dynamic> data) {
    return ApiListResponse<Account>.fromJson(
      data['data'],
      mapper: (el) => Account.fromJson(el),
    );
  }

  ApiListResponse<AccountPermission> _mapPermissions(
      Map<String, dynamic> data) {
    return ApiListResponse<AccountPermission>.fromJson(
      data['data'],
      mapper: (el) => AccountPermission.fromJson(el),
    );
  }

  Account _mapToObject(Map<String, dynamic> data) =>
      Account.fromJson(data['data']);
}
