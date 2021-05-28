import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';

class SecurityService extends ServiceBase {
  SecurityService({Client client})
      : super(
          interceptors: [
            InjectTokenInterceptor(),
          ],
        );

  /// This requests a pin change for the current authenticated user
  /// When the user has the pin is already set in the user
  Future<dynamic> changePin({
    @required String pin,
    @required String repin,
    @required String smscode,
    @required String password,
  }) {
    var path = ApiPaths.changePin.toUri();

    return post(
      path,
      body: {
        pin: pin,
        repin: repin,
        smscode: smscode,
        password: password,
      },
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

    return post(
      path,
      body: {
        pin: pin,
        repin: repin,
        smscode: smscode,
      },
    );
  }

  /// This requests a passwrod change for the current authenticated user
  Future<dynamic> changePassword({
    String password,
    String repassword,
    String smscode,
  }) {
    var path = ApiPaths.changePin.toUri();

    return post(
      path,
      body: {
        password: password,
        repassword: repassword,
        smscode: smscode,
        password: password,
      },
    );
  }
}
