import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/Wallet/transaction_icon.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

import '../../mocks/campaign_mock.dart';
import '../../mocks/storage_mock.dart';
import '../../mocks/transactions_mock.dart';
import '../../mocks/users_mock.dart';
import '../../test_utils.dart';

void main() {
  group('TransactionIcon', () {
    testWidgets('does build correctly', (tester) async {
      await dotenv.load(fileName: "env/.env-test");
      await tester.runAsync(() async {
        final title = TransactionIcon(TransactionMock.transactionIn);
        await tester.pumpWidget(
          await TestUtils.wrapPrivateRoute(title),
        );

        // Esto espera a que este todo cargado
        await tester.pumpAndSettle();
        TestUtils.widgetExists(title);
      });
    });

    expectIconToBe({
      required WidgetTester tester,
      required Transaction transaction,
      String? expectedImageUrl,
      IconData? expectedIcon,
      UserState? state,
      CampaignProvider? campaignsProvider,
    }) async {
      final title = TransactionIcon(transaction);
      await dotenv.load(fileName: "env/.env-test");
      await tester.pumpWidget(
        await TestUtils.wrapPrivateRoute(
          title,
          userState: state,
          campaignsProvider: campaignsProvider,
        ),
      );

      // Esto espera a que este todo cargado
      await tester.pumpAndSettle();
      TestUtils.widgetExists(title);

      if (expectedImageUrl != null) {
        final widget = tester.element(find.byType(CircleAvatarRec)).widget as CircleAvatarRec;
        final url = widget.imageUrl;
        expect(url, expectedImageUrl);
      }

      if (expectedIcon != null) {
        final widget = tester.element(find.byType(CircleAvatarRec)).widget as CircleAvatarRec;
        final icon = widget.icon?.icon;
        expect(icon, expectedIcon);
      }
    }

    testWidgets('Displays icon correctly for ltab reward transaction', (tester) async {
      await tester.runAsync(() async {
        await expectIconToBe(
          tester: tester,
          transaction: TransactionMock.ltabInReward,
          expectedImageUrl: CampaignsMocks.campaignLtab['image_url'],
          state: UserState(
            StorageMock(),
            null,
            user: UserMocks.userLtab(),
          ),
          campaignsProvider: CampaignProvider(
            campaigns: [
              Campaign.fromJson(CampaignsMocks.campaignLtab),
            ],
          ),
        );
      });
    });

    testWidgets('Displays title correctly for culture reward transaction', (tester) async {
      await tester.runAsync(() async {
        await expectIconToBe(
          tester: tester,
          transaction: TransactionMock.cultureRewards,
          expectedImageUrl: CampaignsMocks.campaignCulture['image_url'],
          campaignsProvider: CampaignProvider(
            campaigns: [
              Campaign.fromJson(CampaignsMocks.campaignCulture),
            ],
          ),
        );
      });
    });

    testWidgets('Displays title correctly for recharge transaction', (tester) async {
      await tester.runAsync(() async {
        await expectIconToBe(
          tester: tester,
          transaction: TransactionMock.transactionRecharge,
          expectedIcon: Icons.credit_card,
        );
      });
    });

    testWidgets('Displays title correctly for out transaction', (tester) async {
      await tester.runAsync(() async {
        await expectIconToBe(
          tester: tester,
          transaction: TransactionMock.transactionOut..payOutInfo!.image = 'pay-out-image',
          expectedImageUrl: 'pay-out-image',
        );
      });
    });

    testWidgets('Displays title correctly for in transaction', (tester) async {
      await tester.runAsync(() async {
        await expectIconToBe(
          tester: tester,
          transaction: TransactionMock.transactionIn..payInInfo!.image = 'pay-in-image',
          expectedImageUrl: 'pay-in-image',
        );
      });
    });
  });
}
