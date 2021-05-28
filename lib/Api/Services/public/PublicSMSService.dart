import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectAppTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';

/// Service to manage app-level sms codes
/// Used for public requests, like validating phone
class PublicSMSService extends ServiceBase {
  static String SMS_FORGOT_PASSWORD = 'forget-password';
  static String SMS_VALIDATE_PHONE = 'validate-phone';
  static final List<String> SMS_TYPES = [
    SMS_FORGOT_PASSWORD,
    SMS_VALIDATE_PHONE
  ];

  PublicSMSService({Client client})
      : super(
          client: client,
          interceptors: [InjectAppTokenInterceptor()],
        );

  Future sendSms({
    Map<String, String> data,
    String type,
  }) async {
    // Checks if the type if valid
    assert(
      SMS_TYPES.contains(type),
      'Type must be one of ${SMS_TYPES.join(', ')}',
    );

    var pathWithParams = ApiPaths.sendPublicSmsCode.withId(type).toUri();
    return this.post(pathWithParams, data);
  }

  Future sendForgotPasswordSms({
    String dni,
    String prefix,
    String phone,
  }) async {
    var data = {
      'dni': dni,
      'prefix': prefix,
      'phone': phone,
    };
    return sendSms(data: data, type: SMS_FORGOT_PASSWORD);
  }

  Future sendValidatePhoneSms({
    String prefix,
    String phone,
  }) async {
    var data = {
      'prefix': prefix,
      'phone': phone,
    };
    return sendSms(data: data, type: SMS_FORGOT_PASSWORD);
  }
}
