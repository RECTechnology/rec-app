import 'package:rec/Api/ApiAdapter.dart';

class BlockchainAdapter extends ApiAdapter {
  bool isEnabled = false;

  BlockchainAdapter() : super('blockchain');

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
