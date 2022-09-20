/// This class holds the assets for the application
///
/// You will not need to instantiate this class directly most likely
///
/// Instead prefer using [sharedAssets] located in `lib/config/themes/asset_theme_shared.dart`
class RecAssetTheme {
  final String logo;
  final String avatar;
  final String avatarDisabled;
  final String companyAvatar;
  final String companyAvatarDisabled;
  final String currency;
  final String loginHeader;
  final String rechargeKo;
  final String rechargeOk;

  final String cardVisa;
  final String cardMastercard;
  final String cardAmericanExpress;
  final String languageEs;
  final String languageEn;
  final String languageCat;

  final String markerNormal;
  final String markerNormalOffers;

  final String markerLtab;
  final String markerLtabOffer;

  final String markerCulture;
  final String markerCultureOffers;

  final String markerComercVerd;
  final String markerComercVerdOffers;

  // TODO: Remove from here and load from API
  final String ltabCampaignBanner = 'assets/current/banners/banner_ltab.jpg';
  final String cultureCampaignBanner = 'assets/current/banners/banner_cultural.png';

  RecAssetTheme({
    required this.logo,
    required this.avatar,
    required this.avatarDisabled,
    required this.companyAvatar,
    required this.companyAvatarDisabled,
    required this.currency,
    required this.loginHeader,
    required this.rechargeKo,
    required this.rechargeOk,
    required this.cardVisa,
    required this.cardMastercard,
    required this.cardAmericanExpress,
    required this.languageEs,
    required this.languageEn,
    required this.languageCat,
    required this.markerNormal,
    required this.markerNormalOffers,
    required this.markerLtab,
    required this.markerLtabOffer,
    required this.markerCulture,
    required this.markerCultureOffers,
    required this.markerComercVerd,
    required this.markerComercVerdOffers,
  });
}
