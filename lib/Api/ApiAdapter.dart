class CrudInterface {
  Future list(String path, Map data) {}
  Future get(String path, Map data) {}
  Future edit(String path, Map data) {}
  Future create(String path, Map data) {}
  Future delete(String path, Map data) {}
}

abstract class ApiAdapter implements CrudInterface {
  String name = 'adapter';
  bool isEnabled = false;

  ApiAdapter(this.name);

  @override
  Future create(String path, Map data);

  @override
  Future delete(String path, Map data);

  @override
  Future edit(String path, Map data);

  @override
  Future get(String path, Map data);

  @override
  Future list(String path, Map data);
}
