import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Interfaces/ApiListResponse.dart';
import 'package:rec/Api/Services/ServiceBase.dart';
import 'package:rec/Entities/Marck.ent.dart';

class MapsService extends ServiceBase {
  MapsService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],);

  Future<ApiListResponse<Marck>> getMarks(
      {String search,
      String on_map,
      String type,
      String subtype,
      String only_with_offers,
      String accesToken}) async {
    print("Im in on map Service");
    print(accesToken);

    var pathWithParams = ApiPaths.mapService.withQueryParams({
      'access_token': '$accesToken',
      'search': '',
      'on_map': 'true',
      'only_with_offers': '$only_with_offers',
      'type': '$type',
      'subtype': '$subtype',
      'offset': '0',
      'limit': '300',
      'sort': 'name',
      'order': 'DESC',
    }).toUri();

    return this.get(pathWithParams).then(_mapToApiListReponse);
  }

  ApiListResponse<Marck> _mapToApiListReponse(Map<String, dynamic> data) {
    return ApiListResponse<Marck>.fromJson(
      data['data'],
      mapper: (el) => Marck.fromJson(el),
    );
  }
}
