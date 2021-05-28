import 'package:http_interceptor/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:rec/Api/Services/Public/AppService.dart';

class InjectAppTokenInterceptor implements InterceptorContract {
  AppService appService = AppService();

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    var tokens = await appService.getAppToken();
    data.headers['Authorization'] = 'Bearer ${tokens['access_token']}';
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}
