import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Entities/Campaign.ent.dart';

import '../mocks/campaign_mock.dart';

void main() {
  test('Campaign.fromJson builds correctly', () async {
    var campaign1 = Campaign.fromJson(
      CampaignsMocks.campaign1Json,
    );
    expect(campaign1 == null, false);

    var campaign2 = Campaign.fromJson(
      CampaignsMocks.campaign2Json,
    );
    expect(campaign2 == null, false);
  });

  test('Bonus enabled works', () async {
    var campaign1 = Campaign.fromJson(
      CampaignsMocks.campaign1Json,
    );
    expect(campaign1.bonusEnabled, true);
  });
}
