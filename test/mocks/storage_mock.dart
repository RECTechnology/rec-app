import 'package:rec_api_dart/src/storage.dart';

class StorageMock implements IStorage {
  final Map<String, dynamic> _mockStorage = {};

  @override
  Future<void> delete({required String key}) async {
    _mockStorage.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _mockStorage.removeWhere((key, value) => true);
  }

  @override
  Future<String?> read({required String key}) async {
    return _mockStorage[key];
  }

  @override
  Future<void> write({required String key, String? value}) async {
    _mockStorage[key] = value;
  }
}
