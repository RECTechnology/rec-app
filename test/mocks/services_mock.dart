import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:rec/Api/Services/DocumentsService.dart';
import 'package:rec/Api/Services/wallet/TransactionsService.dart';

import 'transactions_mock.dart';

class ServicesMock {
  static DocumentsService docsService = DocumentsService(
    client: MockClient(
      (request) {
        final mapJson = {'data': {}};
        return Future.value(Response(json.encode(mapJson), 200));
      },
    ),
  );

  static TransactionsService txService = TransactionsService(
    client: MockClient(
      (request) {
        final mapJson = {
          'data': {
            'elements': [
              TransactionMock.transactionIn.toJson(),
            ],
            'total': 0
          }
        };
        return Future.value(Response(json.encode(mapJson), 200));
      },
    ),
  );
}
