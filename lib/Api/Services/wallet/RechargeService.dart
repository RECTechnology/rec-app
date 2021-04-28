import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Forms/RechargeData.dart';
import 'package:rec/Entities/Transactions/RechargeResult.dart';

class RechargeService extends ServiceBase {
  RechargeService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  Future<RechargeResult> recharge(RechargeData data) {
    final uri = ApiPaths.rechargeRecs.toUri();
    final body = data.toJson();
    return this.post(uri, body).then(_onResponse);
  }

  RechargeResult _onResponse(Map<String, dynamic> data) {
    return RechargeResult.fromJson(data);
  }
}
