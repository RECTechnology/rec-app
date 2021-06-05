import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/transactions/TransactionsList.tab.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';

import '../../../mocks/services_mock.dart';
import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  testWidgets('TransactionList builds correctly', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPrivateRoute(
      TransactionsList(),
      state: UserState(
        RecStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
      providers: [
        ChangeNotifierProvider(
          create: (context) => TransactionProvider(ServicesMock.txService),
        ),
      ],
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(TransactionsList);
  });
}
