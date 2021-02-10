import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Api/ApiClient.dart';

import '../lib/Api/Adapters/HttpAdapter.dart';

void main() {
  test('ApiClient should instantiate', () {
    ApiClient client = new ApiClient(adapters: [HttpAdapter()]);
    expect(client != null, true);
  });

  test('ApiClient should instantiate', () {
    ApiClient client = new ApiClient(adapters: [HttpAdapter()]);
    client.users.create({});
  });
}
