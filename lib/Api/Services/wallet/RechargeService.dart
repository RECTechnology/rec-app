import 'package:http/http.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Services/ServiceBase.dart';

class RechargeService extends ServiceBase {
  RechargeService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );
}
