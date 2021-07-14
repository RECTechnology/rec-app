import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Services/CampaignService.dart';
import 'package:rec/Entities/Campaign.ent.dart';
import 'package:rec/Environments/env.dart';

class CampaignProvider extends ChangeNotifier {
  final CampaignsService _service;
  Campaign _activeCampaign;

  Campaign get activeCampaign => _activeCampaign;

  set activeCampaign(Campaign campaign) {
    _activeCampaign = campaign;
    notifyListeners();
  }

  CampaignProvider({
    CampaignsService service,
  }) : _service = service ?? CampaignsService();

  Future<void> load() async {
    activeCampaign = await _service.getActiveCampaign(env);
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
    CampaignsService service,
  }) {
    return ChangeNotifierProvider(
      create: (context) => CampaignProvider(
        service: service,
      ),
    );
  }
}
