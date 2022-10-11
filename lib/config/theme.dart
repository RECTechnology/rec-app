import 'package:flutter/material.dart';
import 'package:rec/config/text_theme.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

import 'asset_theme.dart';

/// Custom theme class containing the theme for the REC app
///
/// This allows us to easily create different themes for each whitelabel project
///
/// Some themes are already created and located in `lib/config/themes`
class RecThemeData {
  final Color primaryColor;
  final Color accentColor;

  final Color red;
  final Color green;
  final Color green2;

  final Color negativeAmount;
  final Color positiveAmount;

  final Color backgroundPrivateColor;
  final Color backgroundCompanyColor;
  final Color backgroundBanner;
  final Color backgroundBannerCulture;

  final Color defaultAvatarBackground;
  final Color separatorColor;

  final Color redLight;
  final Color filterColor;

  // Text Colors
  final Color grayDark;
  final Color grayDark2;
  final Color grayDark3;
  final Color grayLight;
  final Color grayLight2;
  final Color grayLight3;

  final Brightness brightness = Brightness.light;

  // Gradients
  final LinearGradient gradientPrimary;
  final LinearGradient gradientSecondary;
  final LinearGradient gradientGray;

  final RecAssetTheme assets;
  late RecTextTheme textTheme;

  RecThemeData({
    required this.primaryColor,
    required this.accentColor,
    required this.red,
    required this.green,
    required this.green2,
    required this.negativeAmount,
    required this.positiveAmount,
    required this.backgroundPrivateColor,
    required this.backgroundCompanyColor,
    required this.backgroundBanner,
    required this.backgroundBannerCulture,
    required this.defaultAvatarBackground,
    required this.separatorColor,
    required this.redLight,
    required this.filterColor,
    required this.grayDark,
    required this.grayDark2,
    required this.grayDark3,
    required this.grayLight,
    required this.grayLight2,
    required this.grayLight3,
    required this.assets,
    required Color gradientPrimaryLight,
    required Color gradientPrimaryDark,
    required Color gradientSecondaryLight,
    required Color gradientSecondaryDark,
    required Color gradientGrayLight,
    required Color gradientGrayDark,
  })  : gradientPrimary = LinearGradient(
          begin: Alignment(.5, 1.3),
          end: Alignment(-.3, -0.8),
          colors: <Color>[gradientPrimaryLight, gradientPrimaryDark],
        ),
        gradientSecondary = LinearGradient(
          begin: Alignment(.5, 1.3),
          end: Alignment(-.3, -0.8),
          colors: <Color>[gradientSecondaryLight, gradientSecondaryDark],
        ),
        gradientGray = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[gradientGrayLight, gradientGrayDark],
        ) {
    textTheme = RecTextTheme.fromTheme(this);
  }

  Color accountTypeColor(String type) {
    return type == Account.TYPE_PRIVATE ? primaryColor : accentColor;
  }

  Color accountTypeBackground(String type) {
    return type == Account.TYPE_PRIVATE ? backgroundPrivateColor : backgroundCompanyColor;
  }

  LinearGradient accountTypeGradient(String type) {
    return type == Account.TYPE_PRIVATE ? gradientPrimary : gradientSecondary;
  }

  Color documentColorStatus(String status) {
    if (status == Document.STATUS_EXPIRED) return red;
    if (status == Document.STATUS_DECLINED) return red;
    if (status == Document.STATUS_SUBMITTED) return grayDark3;
    if (status == Document.STATUS_APPROVED) return primaryColor;

    return grayDark3;
  }

  ThemeData getThemeData() {
    final baseTheme = ThemeData();

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      colorScheme: baseTheme.colorScheme.copyWith(primary: primaryColor, secondary: accentColor),
      brightness: brightness,
      dividerColor: separatorColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: baseTheme.appBarTheme.copyWith(
        elevation: 0,
      ),
      dividerTheme: baseTheme.dividerTheme.copyWith(
        color: separatorColor,
      ),
      tabBarTheme: baseTheme.tabBarTheme.copyWith(
        labelColor: primaryColor,
        unselectedLabelColor: grayDark3,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      textTheme: baseTheme.textTheme.copyWith(
        bodyText1: baseTheme.textTheme.bodyText1!.copyWith(
          color: grayDark,
          fontSize: 12,
        ),
        bodyText2: baseTheme.textTheme.bodyText2!.copyWith(
          color: grayDark,
        ),
        headline4: baseTheme.textTheme.headline4!.copyWith(
          color: grayDark3,
          fontSize: 20,
          height: 1.3,
        ),
        headline5: baseTheme.textTheme.headline5!.copyWith(
          color: grayDark,
          fontSize: 24,
        ),
        headline6: baseTheme.textTheme.headline6!.copyWith(
          color: grayDark,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        subtitle1: baseTheme.textTheme.subtitle1!.copyWith(
          color: grayDark2,
          fontSize: 16,
        ),
        subtitle2: baseTheme.textTheme.subtitle2!.copyWith(
          color: primaryColor,
          fontSize: 12,
        ),
        caption: baseTheme.textTheme.caption!.copyWith(
          color: grayDark,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        button: baseTheme.textTheme.button!.copyWith(
          fontSize: 20,
        ),
      ),
    );
  }
}

/// Custom theme widget that stores the current [RecThemeData] and allows us
/// to get access to the current [RecThemeData] by using [RecTheme.of(context)]
///
/// A child [Widget] or [WidgetBuilder] must be provided,
/// as wells as a [RecThemeData] instance
class RecTheme extends StatefulWidget {
  /// Returns the first instance of [RecThemeData] that it can find in the
  /// widget tree
  static RecThemeData? of(BuildContext context, {bool listen = false}) {
    return context.findAncestorWidgetOfExactType<RecTheme>()?.data;
  }

  final Widget? child;
  final WidgetBuilder? builder;
  final RecThemeData? data;

  RecTheme({
    Key? key,
    this.child,
    this.builder,
    this.data,
  })  : assert(child != null || builder != null, "Either child or builder must not be null"),
        super(key: key);

  @override
  State<RecTheme> createState() => _RecThemeState();
}

class _RecThemeState extends State<RecTheme> {
  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return Builder(builder: widget.builder!);
    }

    return widget.child ?? SizedBox.shrink();
  }
}
