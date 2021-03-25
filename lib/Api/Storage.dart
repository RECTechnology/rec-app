import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecStorage {
  FlutterSecureStorage storage;

  RecStorage() {
    storage = FlutterSecureStorage();
  }

  Future<String> read({String key}) {
    return storage.read(key: key);
  }

  Future<void> write({String key, String value}) {
    return storage.write(key: key, value: value);
  }

  Future<void> delete({String key}) {
    return storage.delete(key: key);
  }

  Future<void> deleteAll() {
    return storage.deleteAll();
  }
}
