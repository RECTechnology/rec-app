import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Interfaces/ApiListResponse.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/DocumentKind.ent.dart';

class DocumentsService extends ServiceBase {
  DocumentsService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  Future<ApiListResponse<DocumentKind>> listKinds() {
    final uri = ApiPaths.documentKinds.toUri();

    return this.get(uri).then(_mapToApiListReponse);
  }

  ApiListResponse<DocumentKind> _mapToApiListReponse(
    Map<String, dynamic> data,
  ) {
    return ApiListResponse<DocumentKind>.fromJson(
      data['data'],
      mapper: (el) => DocumentKind.fromJson(el),
    );
  }
}
