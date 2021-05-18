import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectAppTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';

class SMSService extends ServiceBase {
  static String TYPE_FORGOT_PASSWORD = 'forget-password';
  static String TYPE_VALIDATE_PHONE = 'validate-phone';

  SMSService({Client client})
      : super(
          client: client,
          interceptors: [InjectAppTokenInterceptor()],
        );

  Future sendPublicSms({
    Map<String, String> data,
    String type,
  }) async {
    var pathWithParams = ApiPaths.sendPublicSmsCode.withId(type).toUri();
    return this.post(pathWithParams, data);
  }

  Future sendForgotPasswordSms({
    String dni,
    String prefix,
    String phone,
  }) async {
    var path = ApiPaths.sendPublicSmsCode.withId(TYPE_FORGOT_PASSWORD).toUri();
    var data = {
      'dni': dni,
      'prefix': prefix,
      'phone': phone,
    };
    return this.post(path, data);
  }

  Future sendValidatePhoneSms({
    String prefix,
    String phone,
  }) async {
    var path = ApiPaths.sendPublicSmsCode.withId(TYPE_VALIDATE_PHONE).toUri();
    var data = {
      'prefix': prefix,
      'phone': phone,
    };
    return this.post(path, data);
  }
}
