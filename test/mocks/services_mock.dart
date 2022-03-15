import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'account_permissions_mock.dart';
import 'campaign_mock.dart';
import 'transactions_mock.dart';

class ServicesMock {
  static DocumentsService docsService = DocumentsService(
    env: Env(),
    client: MockClient(
      (request) {
        final mapJson = {
          'data': {},
        };
        return Future.value(Response(json.encode(mapJson), 200));
      },
    ),
  );

  static CampaignsService campaignService = CampaignsService(
    env: Env(),
    client: MockClient(
      (request) {
        final mapJson = {
          'data': CampaignsMocks.campaign1.toJson(),
        };
        return Future.value(Response(json.encode(mapJson), 200));
      },
    ),
  );

  static TransactionsService createTxService(Map<String, dynamic> data, {int statusCode = 200}) {
    return TransactionsService(
      env: Env(),
      client: MockClient(
        (request) {
          return Future.value(
            Response(json.encode(data), statusCode),
          );
        },
      ),
    );
  }

  static TransactionsService txService = createTxService({
    'data': {
      'elements': [
        TransactionMock.transactionIn.toJson(),
      ],
      'total': 0
    }
  });

  static TransactionsService txServiceDaySummary = createTxService({
    'data': {
      'in': 0,
      'out': 0,
      'total': 0,
    }
  });

  static AccountsService accountsService = AccountsService(
    env: Env(),
    client: MockClient(
      (request) {
        var elements = [];

        if (request.url.path.contains(ApiPaths.accountsPermissions.path)) {
          elements = [
            AccountPermissionsMock.permission1,
          ];
        }

        final mapJson = {
          'data': {'elements': elements, 'total': 0}
        };
        return Future.value(Response(json.encode(mapJson), 200));
      },
    ),
  );
}
