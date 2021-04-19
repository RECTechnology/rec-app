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
      String accesToken,
      String limit,
      String order,
      String offSet}) async {

    var query = <String,dynamic>{
      'search': '',
      'on_map': 'true',
      'only_with_offers': 'false',
      'type': 'COMPANY',
      'subtype': '',
    };

    var pathWithParams = ApiPaths.mapService.withQueryParams({
      'offset': '0',
      'limit': '300',
      'sort': 'name',
      'order': 'DESC',
      'query': '$query',

    }).toUri();
    print(pathWithParams);
    // ignore: missing_return
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
