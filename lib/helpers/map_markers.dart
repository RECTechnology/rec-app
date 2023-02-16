import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec/config/asset_theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/ImageHelpers.dart';
import 'package:rec/helpers/account_helper.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class MapMarkers {
  static Map<String, BitmapDescriptor> markers = {};
  static BitmapDescriptor? markerNormal;
  static BitmapDescriptor? markerOffers;
  static BitmapDescriptor? markerLtab;
  static BitmapDescriptor? markerLtabOffers;
  static BitmapDescriptor? markerCulture;
  static BitmapDescriptor? markerCultureOffers;
  static BitmapDescriptor? markerComercVerd;
  static BitmapDescriptor? markerComercVerdOffers;
  static bool hasLoaded = false;

  static Future<BitmapDescriptor> getMarkerFromAsset(
    String assetPath, {
    int width = 80,
  }) async {
    final markerBytes = await ImageHelpers.getBytesFromAsset(assetPath, width);
    return markers[assetPath] = BitmapDescriptor.fromBytes(markerBytes);
  }

  static Future loadMarkers(RecAssetTheme assets) async {
    markerNormal = await getMarkerFromAsset(assets.markerNormal);
    markerOffers = await getMarkerFromAsset(assets.markerNormalOffers);

    markerLtab = await getMarkerFromAsset(assets.markerLtab);
    markerLtabOffers = await getMarkerFromAsset(assets.markerLtabOffer);

    markerCulture = await getMarkerFromAsset(assets.markerCulture);
    markerCultureOffers = await getMarkerFromAsset(assets.markerCultureOffers);

    markerComercVerd = await getMarkerFromAsset(assets.markerComercVerd);
    markerComercVerdOffers = await getMarkerFromAsset(assets.markerComercVerdOffers);

    hasLoaded = true;
  }

  /// Used to get an icon for a given [MapAccountData] instance
  /// it will return a [BitmapDescriptor] for a marker based on some predicates
  static BitmapDescriptor? getMarkerForAccount(MapAccountData account, BuildContext context) {
    if (!hasLoaded) {
      throw Exception(
        'MapMarkers has not loaded the assets yet, please run `await loadMarkers()` before using `getMarkerForAccount`',
      );
    }

    final ltabCampaign = CampaignProvider.deaf(context).getCampaignByCode(env.CMP_LTAB_CODE);
    final cultureCampaign = CampaignProvider.deaf(context).getCampaignByCode(env.CMP_CULT_CODE);
    final isAccountInLtab = AccountHelper.mapAccountIsInLtabCampaign(account);
    final isAccountInCult = AccountHelper.mapAccountIsInCultureCampaign(account);
    final isComerceVerd = account.isCommerceVerd == true;
    final isCulture = account.isCulture == true;

    // Only show LTAB marker if the account is part of the campaign,
    // and the campaign is not finished
    final isLTabMarker = isAccountInLtab && ltabCampaign!.isStarted() && !ltabCampaign.isFinished();

    // Only show CULTURE marker if the account is part of the campaign,
    // and the campaign is not finished
    final isCultureMarker = isCulture ||
        (isAccountInCult &&
            cultureCampaign != null &&
            cultureCampaign.isStarted() &&
            !cultureCampaign.isFinished());

    // Handle offer markers
    if (account.hasOffers == true) {
      if (isComerceVerd) return MapMarkers.markerComercVerdOffers;
      if (isLTabMarker) return MapMarkers.markerLtabOffers;
      if (isCultureMarker) return MapMarkers.markerCultureOffers;

      return MapMarkers.markerOffers;
    }

    // Handle normal (non-offer) markers
    if (isComerceVerd) return MapMarkers.markerComercVerd;
    if (isLTabMarker) return MapMarkers.markerLtab;
    if (isCultureMarker) return MapMarkers.markerCulture;

    return MapMarkers.markerNormal;
  }
}
