import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Text/OfferDiscount.dart';
import 'package:rec/Components/Text/RecAmountText.dart';

import '../mocks/offers_mock.dart';
import '../test_utils.dart';

void main() {
  testWidgets('OfferDiscount works', (WidgetTester tester) async {
    var widget = OfferDiscount(offer: OffersMock.percentOffer);

    await tester.pumpWidget(await TestUtils.wrapPublicWidget(widget));
    await tester.pumpAndSettle();

    TestUtils.widgetExists(widget);
    TestUtils.widgetExistsByType(RecAmountText);
    TestUtils.isTextPresent('-10.00%');
  });
}
