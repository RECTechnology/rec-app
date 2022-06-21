import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/config/assets.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/styles/text_styles.dart';
import 'package:rec/app.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ChangeLanguagePage extends StatefulWidget {
  ChangeLanguagePage({Key? key}) : super(key: key);

  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  final _userService = UsersService(env: env);
  final _languageCards = [
    LanguageCardData(
      id: 'es',
      image: AssetImage(Assets.languageEs),
    ),
    LanguageCardData(
      id: 'en',
      image: AssetImage(Assets.languageEn),
    ),
    LanguageCardData(
      id: 'ca',
      image: AssetImage(Assets.languageCat),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var currentLocale = localizations!.locale;
    var mainLanguage = _getMainLanguage();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(context, title: 'LANGUAGE'),
      body: Column(
        children: [
          GeneralSettingsTile(
            title: localizations.getLocaleNameByLocaleId(mainLanguage.id!),
            subtitle: 'MAIN_LANGUAGE',
            circleAvatar: CircleAvatarRec(
              radius: 27,
              image: mainLanguage.image,
            ),
            subtitleStyle: TextStyles.outlineTileText.copyWith(
              color: Brand.graySubtitle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 22),
            child: SectionTitleTile('AVAILABLE'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _languageCards.length,
              itemBuilder: (context, index) {
                var languageCard = _languageCards[index];
                var isSelectedLocale = languageCard.id == currentLocale.languageCode;

                if (!isSelectedLocale) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GeneralSettingsTile(
                      title: localizations.getLocaleNameByLocaleId(
                        languageCard.id!,
                      ),
                      onTap: () => _changeLanguage(languageCard.id),
                      titleStyle: TextStyles.outlineTileText.copyWith(
                        fontWeight: FontWeight.w300,
                        color: Brand.grayDark,
                      ),
                      circleAvatar: CircleAvatarRec(
                        radius: 27,
                        image: languageCard.image,
                      ),
                    ),
                  );
                }

                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  LanguageCardData _getMainLanguage() {
    var localizations = AppLocalizations.of(context);

    for (var lang in _languageCards) {
      if (lang.id == localizations!.locale.languageCode) return lang;
    }

    return _languageCards[0];
  }

  void _changeLanguage(String? locale) {
    Loading.show();

    _userService.changeLanguage(locale).then((value) {
      RecApp.setLocale(context, Locale(locale!, locale));
      Loading.dismiss();
      Navigator.of(context).pop();
    }).catchError(_onError);

    setState(() {});
  }

  _onError(error) {
    Loading.dismiss();
    RecToast.showError(context, error.message);
  }
}
