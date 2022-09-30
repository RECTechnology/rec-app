import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/app.dart';

void main() {
  testWidgets('RecApp builds', (WidgetTester tester) async {
    await dotenv.load(fileName: "env/.env-test");
    var app = RecApp();
    await tester.pumpWidget(app);

    expect(find.byWidget(app), findsOneWidget);
  });
}
