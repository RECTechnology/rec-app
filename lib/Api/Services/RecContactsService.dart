import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Interfaces/ApiListResponse.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/ContactInfo.dart';

class RecContactsService extends ServiceBase {
  RecContactsService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  Future<ApiListResponse<ContactInfo>> getContacts(
    List<String> phoneList,
  ) async {
    var pathWithParams = ApiPaths.getContacts.toUri();

    return this.post(pathWithParams, {
      'phone_list': phoneList,
    }).then((value) {
      return _mapToApiListReponse(value);
    });
  }

  ApiListResponse<ContactInfo> _mapToApiListReponse(Map<String, dynamic> data) {
    return ApiListResponse<ContactInfo>.fromJson(
      {'elements': data['data']},
      mapper: (el) => ContactInfo.fromJson(el),
    );
  }
}
