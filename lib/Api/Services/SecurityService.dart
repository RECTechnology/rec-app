import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Forms/ChangePasswordData.dart';
import 'package:rec/Entities/Forms/ChangePinData.dart';

class SecurityService extends ServiceBase {
  SecurityService({Client client})
      : super(
          interceptors: [
            InjectTokenInterceptor(),
          ],
        );

  /// This requests a pin change for the current authenticated user
  /// When the user has the pin is already set in the user
  Future<dynamic> changePin(ChangePinData data) {
    var path = ApiPaths.changePin.toUri();

    return this.put(
      path,
      data.toJson(),
    );
  }

  /// This requests to create/set the pin initially for the current authenticated user
  /// When the user has no pin set already
  Future<dynamic> createPin({
    @required String pin,
    @required String repin,
    @required String smscode,
  }) {
    var path = ApiPaths.changePin.toUri();

    return this.put(
      path,
      {
        'pin': pin,
        'repin': repin,
        'sms_code': smscode,
      },
    );
  }

  /// This requests a passwrod change for the current authenticated user
  Future<dynamic> changePassword(ChangePasswordData data) {
    var path = ApiPaths.changePassword.toUri();

    return this.put(
      path,
      data.toJson(),
    );
  }
}
