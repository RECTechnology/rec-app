import 'package:rec/Api/ApiAdapter.dart';
import 'package:rec/Api/ApiClient.dart';

abstract class ServiceBase {
  ApiClient client;
  List<ApiAdapter> adapters;
  ApiAdapter defaultAdapter;

  ServiceBase(
      ApiClient client, List<ApiAdapter> adapters, ApiAdapter defaultAdapter) {
    if (client == null) {
      throw Exception("ServiceBase: client is required");
    }
    if (adapters == null || adapters.isEmpty) {
      throw Exception("ServiceBase: at least one adapter is required");
    }

    if (defaultAdapter == null) {
      this.defaultAdapter = adapters.firstWhere((element) => element.isEnabled);
    } else {
      this.defaultAdapter = defaultAdapter;
    }

    this.client = client;
    this.adapters = adapters;
  }

  String getPath({String method, Map params});
  ApiAdapter getAdapter({String method, Map params});

  Future edit(String id, Map data) {
    var path = this.getPath(method: 'edit', params: {id: id});
    var adapter = this.getAdapter(method: 'edit', params: {id: id});

    return adapter.edit(path, data);
  }

  Future create(Map data) {
    throw UnimplementedError();
  }

  Future delete(String id) {
    throw UnimplementedError();
  }

  Future get(String id) {
    throw UnimplementedError();
  }

  Future list() {
    throw UnimplementedError();
  }
}
