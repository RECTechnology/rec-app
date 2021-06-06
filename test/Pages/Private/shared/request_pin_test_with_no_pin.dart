import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Pages/Private/Shared/CreatePin.dart';
import 'package:rec/Pages/Private/Shared/RequestPin.page.dart';
import 'package:rec/Providers/UserState.dart';
import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  testWidgets('RequestPin shows CreatePin if user has no pin', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPrivateRoute(
      RequestPin(
        ifPin: (pin) => print('got pin $pin'),
      ),
      state: UserState(
        RecSecureStorage(),
        null,
        user: UserMocks.userNormal()..hasPin = false,
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(CreatePinWidget);
  });
}
