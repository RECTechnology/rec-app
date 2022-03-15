import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/ImageHelpers.dart';
import 'package:rec/config/assets.dart';
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
  static bool hasLoaded = false;

  static Future<BitmapDescriptor> getMarkerFromAsset(
    String assetPath, {
    int width = 80,
  }) async {
    var markerBytes = await ImageHelpers.getBytesFromAsset(assetPath, width);
    return markers[assetPath] = BitmapDescriptor.fromBytes(markerBytes);
  }

  static Future loadMarkers() async {
    markerNormal = await getMarkerFromAsset(Assets.markerNormal);
    markerOffers = await getMarkerFromAsset(Assets.markerNormalOffers);

    markerLtab = await getMarkerFromAsset(Assets.markerLtab);
    markerLtabOffers = await getMarkerFromAsset(Assets.markerLtabOffer);

    markerCulture = await getMarkerFromAsset(Assets.markerCulture);
    markerCultureOffers = await getMarkerFromAsset(Assets.markerCultureOffers);

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

    var ltabCampaign = CampaignProvider.deaf(context).getCampaignByCode(env.CMP_LTAB_CODE);
    var cultureCampaign = CampaignProvider.deaf(context).getCampaignByCode(env.CMP_CULT_CODE);
    var isAccountInLtab = AccountHelper.mapAccountIsInLtabCampaign(account);
    var isAccountInCult = AccountHelper.mapAccountIsInCultureCampaign(account);

    // Only show LTAB marker if the account is part of the campaign,
    // and the campaign is not finished
    var isLTabMarker = isAccountInLtab && ltabCampaign!.isStarted() && !ltabCampaign.isFinished();

    // Only show CULTURE marker if the account is part of the campaign,
    // and the campaign is not finished
    var isCultureMarker =
        isAccountInCult && cultureCampaign!.isStarted() && !cultureCampaign.isFinished();

    // Check offers
    if (isLTabMarker && account.hasOffers!) {
      return MapMarkers.markerLtabOffers;
    }

    if (isCultureMarker && account.hasOffers!) {
      return MapMarkers.markerCultureOffers;
    }
    if (account.hasOffers!) return MapMarkers.markerOffers;

    // No offers
    if (isLTabMarker && !account.hasOffers!) {
      return MapMarkers.markerLtab;
    }

    if (isCultureMarker && !account.hasOffers!) {
      return MapMarkers.markerCulture;
    }

    return MapMarkers.markerNormal;
  }
}
