import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Pages/Private/Shared/EnterPin.page.dart';
import 'package:rec/Pages/Private/Shared/RequestPin.page.dart';
import 'package:rec/Providers/UserState.dart';
import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  testWidgets('RequestPin shows EnterPin if user has pin', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPrivateRoute(
      RequestPin(
        ifPin: (pin) => print('got pin $pin'),
      ),
      state: UserState(
        RecSecureStorage(),
        null,
        user: UserMocks.userNormal()..hasPin = true,
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(find.byType(EnterPin), findsOneWidget);
  });
}
