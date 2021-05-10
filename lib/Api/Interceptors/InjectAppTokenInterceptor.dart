import 'package:http_interceptor/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:rec/Api/Auth.dart';

class InjectAppTokenInterceptor implements InterceptorContract {
  InjectAppTokenInterceptor();

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    var token = await Auth.getAppToken();
    data.headers['Authorization'] = 'Bearer $token';
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}
