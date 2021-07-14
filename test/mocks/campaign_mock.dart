import 'package:rec/Entities/Campaign.ent.dart';

import '../test_faker.dart';

class CampaignsMocks {
  static Map<String, dynamic> campaign1Json = {
    'id': TestFaker.faker.guid.guid(),
    'created_at': TestFaker.isoDate(),
    'updated_at': TestFaker.isoDate(),
    'init_date': TestFaker.isoDate(),
    'end_date': TestFaker.isoDate(),
    'min': 1,
    'max': 100,
    'balance': 1000,
    'name': 'test_campaign',
    'video_promo_url': '',
    'image_url': TestFaker.faker.image.image(),
  };

  static Campaign campaign1 = Campaign.fromJson(campaign1Json);
}
