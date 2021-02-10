import 'package:rec/Api/ApiAdapter.dart';
import 'package:http/http.dart' as http;

class HttpAdapter extends ApiAdapter {
  bool isEnabled = true;
  http.Client _http;

  HttpAdapter() : super('http') {
    _http = http.Client();
  }

  @override
  Future create(String path, Map data) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future delete(String path, Map data) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future edit(String path, Map data) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future get(String path, Map data) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future list(String path, Map data) {
    // TODO: implement list
    throw UnimplementedError();
  }
}
