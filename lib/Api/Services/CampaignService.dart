import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Campaign.ent.dart';
import 'package:rec/Environments/env.base.dart';

/// This service is in charge of all requests related to [Campaigns]
///
/// * **Authentication Required** - the user must be authenticated
class CampaignsService extends ServiceBase {
  CampaignsService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  /// List all [DocumentKinds]
  Future<Campaign> getOne(String id) {
    final uri = ApiPaths.campaigns.append(id).toUri();

    return this.get(uri).then((res) {
      return Campaign.fromJson(res['data']);
    });
  }

  /// fetches the current active account, for current [Env]
  Future<Campaign> getActiveCampaign(EnvBase env) {
    return getOne(env.CAMPAIGN_ID);
  }
}
