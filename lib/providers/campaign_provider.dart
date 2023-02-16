import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

// final Map<String, dynamic> campaign1Json = {
//   "id": 5,
//   "created": "2021-10-13T12:20:18+00:00",
//   "updated": "2023-01-10T10:10:02+00:00",
//   "init_date": "2022-01-11T00:00:00+00:00",
//   "end_date": "2023-01-31T00:00:00+00:00",
//   "bonus_enabled": true,
//   "name": "V2 campaign",
//   "description": "Lorem ipsum dolor sit amet",
//   "tos": "private_tos_campaign_culture",
//   "min": 0,
//   "max": 200,
//   "redeemable_percentage": 50,
//   "image_url": "https://api.rec.qbitartifacts.com/static/616d3efcc5883.png",
//   "video_promo_url": "www.youtube.com/embed/CKj1doMvkqU",
//   "code": "CULT21",
//   "url_tos": "https://rec.barcelona/es/inicio/",
//   "ending_alert": true,
//   "version": 2,
// };

// final Campaign campaign1 = Campaign.fromJson(campaign1Json);

class CampaignProvider extends ChangeNotifier {
  final CampaignsService _service;
  List<Campaign?>? _campaigns = [];
  List<Campaign?>? get campaigns =>
      (_campaigns ?? []).where((element) => (element?.version ?? 0) <= 1).toList();
  List<Campaign?>? get campaignsV2 =>
      (_campaigns ?? []).where((element) => element?.version == 2).toList();

  bool loading = false;

  CampaignProvider({
    CampaignsService? service,
    List<Campaign?>? campaigns,
  })  : _service = service ?? CampaignsService(env: env),
        _campaigns = campaigns ?? [];

  Future<void> load() async {
    loading = true;
    var campaignListResponse = await _service.listPublic();
    _campaigns = campaignListResponse.items;
    // _campaigns!.add(campaign1);
    loading = false;
    notifyListeners();
  }

  Campaign? getCampaign(
    bool Function(Campaign? element) test, {
    Campaign? Function()? orElse,
  }) {
    return _campaigns!.firstWhere(test, orElse: orElse);
  }

  Campaign? getCampaignByCode(String code) {
    return getCampaign((element) => element!.code == code, orElse: () => null);
  }
  Campaign? getCampaignById(String id) {
    return getCampaign((element) => element!.id == id, orElse: () => null);
  }

  Campaign? firstActiveV2() {
    return (campaignsV2 ?? []).firstWhere(
      (element) => element?.status == Campaign.STATUS_ACTIVE,
      orElse: () => null,
    );
  }

  bool anyActiveV2Campaign() {
    return (campaignsV2 ?? []).any((element) => isCampaignActive(element));
  }

  bool isActive(String code) {
    return isCampaignActive(getCampaignByCode(code));
  }

  bool isCampaignActive(Campaign? campaign) {
    if (Checks.isNull(campaign)) return false;
    return campaign!.isStarted() && !campaign.isFinished();
  }

  static CampaignProvider of(context, {bool listen = true}) {
    return Provider.of<CampaignProvider>(
      context,
      listen: listen,
    );
  }

  static CampaignProvider deaf(context) {
    return of(context, listen: false);
  }

  static ChangeNotifierProvider<CampaignProvider> getProvider({
    CampaignsService? service,
  }) {
    return ChangeNotifierProvider(
      create: (context) => CampaignProvider(
        service: service,
      ),
    );
  }
}
