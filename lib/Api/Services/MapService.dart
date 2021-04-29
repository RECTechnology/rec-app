import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Interfaces/ApiListResponse.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Map/MapSearchData.dart';
import 'package:rec/Entities/Marck.ent.dart';

class MapsService extends ServiceBase {
  MapsService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  Future<ApiListResponse<Marck>> getMarks(MapSearchData searchData) async {
    var pathWithParams = ApiPaths.mapV4
        .withQueryParams(
          searchData.toJson(),
        )
        .toUri();

    return this.get(pathWithParams).then((value) {
      return _mapToApiListReponse(value);
    });
  }

  ApiListResponse<Marck> _mapToApiListReponse(Map<String, dynamic> data) {
    return ApiListResponse<Marck>.fromJson(
      data['data'],
      mapper: (el) => Marck.fromJson(el),
    );
  }
}
