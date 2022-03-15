import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CampaignProvider extends ChangeNotifier {
  final CampaignsService _service;
  List<Campaign?>? _campaigns = [];
  List<Campaign?>? get campaigns => _campaigns;
  bool loading = false;

  CampaignProvider({
    CampaignsService? service,
  }) : _service = service ?? CampaignsService(env: env);

  Future<void> load() async {
    loading = true;
    var campaignListResponse = await _service.list();
    _campaigns = campaignListResponse.items;
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

  bool isActive(String code) {
    var campaign = getCampaignByCode(code);
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
