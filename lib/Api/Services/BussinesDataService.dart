import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Services/ServiceBase.dart';
import 'package:rec/Entities/BussinesData.ent.dart';

class BussinesDataService extends ServiceBase {
  BussinesDataService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  Future<BussinesData> getData(String id) async {
    print("Im in get dataaaaaaaaa");
    var pathWithParams =
        ApiPaths.bussinesDataService.withQueryParams({}).withId(id).toUri();

    return this.get(pathWithParams).then((value) {
      return _mapToObject(value);
    });
  }

  BussinesData _mapToObject(Map<String, dynamic> data) {
    print("iM IN ApiListResponse");
    print(data);
    print("Printing latitudeeeeeeeeeeeeeeeeeeeeee");
    print(data['data']['longitude']);
    return BussinesData(
      data['data']['id'],
      data['data']['name'],
      data['data']['description'],
      data['data']['public_image'],
      data['data']['image'],
      data['data']['prefix'],
      data['data']['phone'],
      data['data']['offers'],
      'Calle '+ data['data']['street']+', '+data['data']['address_number']+', '+data['data']['zip'],
      data['data']['web'],
      data['data']['schedule'],
      data['data']['latitude'],
      data['data']['longitude'],

    );

  }
}
