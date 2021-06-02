import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';

import 'BaseService.dart';

/// Service to manage user-level sms codes
class UserSmsService extends ServiceBase {
  static final String SMS_CHANGE_PIN = 'change-pin';
  static final String SMS_CHANGE_PASSWORD = 'change-password';
  static final List<String> SMS_TYPES = [SMS_CHANGE_PIN, SMS_CHANGE_PASSWORD];

  UserSmsService({Client client})
      : super(
          client: client,
          interceptors: [
            InjectTokenInterceptor(),
          ],
        );

  /// Request to send and SMS for a specific [type]
  /// See [UserSmsService.SMS_TYPES] for all available types
  Future sendSms({
    Map<String, String> data = const {},
    String type,
  }) async {
    // Checks if the type if valid
    assert(
      SMS_TYPES.contains(type),
      'Type must be one of ${SMS_TYPES.join(', ')}',
    );

    var pathWithParams = ApiPaths.sendUserSmsCode.append(type).toUri();
    return this.post(pathWithParams, data);
  }

  /// Request to send an SMS code to change pin
  Future sendChangePinSms() {
    return sendSms(type: SMS_CHANGE_PIN);
  }

  /// Request to send an SMS code to change password
  Future sendChangePasswordSms() {
    return sendSms(type: SMS_CHANGE_PASSWORD);
  }
}
