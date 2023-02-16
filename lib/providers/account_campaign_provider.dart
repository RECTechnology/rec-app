import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AccountCampaignProvider extends ChangeNotifier {
  final AccountCampaignsService _service;
  AccountCampaignList? list;
  List<AccountCampaign?>? _campaigns = [];
  List<AccountCampaign?>? get campaigns => _campaigns;
  bool loading = false;

  AccountCampaignProvider({
    AccountCampaignsService? service,
    List<AccountCampaign?>? campaigns,
  })  : _service = service ?? AccountCampaignsService(env: env),
        _campaigns = campaigns ?? [];

  Future<void> load() async {
    loading = true;
    list = await _service.list(onlyActive: true);
    _campaigns = list?.items ?? [];
    loading = false;
    notifyListeners();
  }

  AccountCampaign? getCampaign(
    bool Function(AccountCampaign? element) test, {
    AccountCampaign? Function()? orElse,
  }) {
    return _campaigns!.firstWhere(test, orElse: orElse);
  }

  AccountCampaign? getForCampaign(Campaign? campaign) {
    if (campaign == null) return null;

    try {
      final camp = getCampaign((el) {
        return el?.campaign.id == campaign.id;
      });

      return camp;
    } catch (e) {
      return null;
    }
  }

  static AccountCampaignProvider of(context, {bool listen = true}) {
    return Provider.of<AccountCampaignProvider>(
      context,
      listen: listen,
    );
  }

  static AccountCampaignProvider deaf(context) {
    return of(context, listen: false);
  }

  static ChangeNotifierProvider<AccountCampaignProvider> getProvider({
    AccountCampaignsService? service,
  }) {
    return ChangeNotifierProvider(
      create: (context) => AccountCampaignProvider(
        service: service,
      ),
    );
  }
}
