import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectAppTokenInterceptor.dart';

import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Forms/UnlockUserData.dart';

class UnlockUserService extends ServiceBase {
  UnlockUserService() : super(interceptors: [InjectAppTokenInterceptor()]);


  Future<Map<String, dynamic>> unlockUser(UnlockUserData data) {

    final uri = ApiPaths.unlockUser.toUri();
    var body = {
      'prefix': data.prefix,
      'phone': data.phone,
      'dni':data.dni,
      'smscode': data.sms,
    };
    print(uri);
    return post(uri,body);
  }


}
