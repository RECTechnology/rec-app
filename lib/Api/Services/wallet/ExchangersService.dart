import 'dart:math';

import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Interfaces/ApiListResponse.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Account.ent.dart';

class ExchangersService extends ServiceBase {
  ExchangersService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  /// list all exchangers
  Future<ApiListResponse<Account>> list() {
    final uri = ApiPaths.getExchangers.toUri();
    return this.get(uri).then(_mapToApiListReponse);
  }

  Future<Account> getRandom() async {
    return await list().then((resp) {
      return resp.items[Random().nextInt(resp.items.length)];
    });
  }

  ApiListResponse<Account> _mapToApiListReponse(Map<String, dynamic> data) {
    return ApiListResponse<Account>.fromJson(
      data['data'],
      mapper: (el) => Account.fromJson(el),
    );
  }
}
