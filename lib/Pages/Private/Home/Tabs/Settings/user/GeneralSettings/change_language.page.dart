import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/app.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ChangeLanguagePage extends StatefulWidget {
  ChangeLanguagePage({Key? key}) : super(key: key);

  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  final _userService = UsersService(env: env);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final localizations = AppLocalizations.of(context);
    final currentLocale = localizations!.locale;
    final languageCards = [
      LanguageCardData(
        id: 'es',
        image: AssetImage(recTheme!.assets.languageEs),
      ),
      LanguageCardData(
        id: 'en',
        image: AssetImage(recTheme.assets.languageEn),
      ),
      LanguageCardData(
        id: 'ca',
        image: AssetImage(recTheme.assets.languageCat),
      ),
    ];
    final mainLanguage = _getMainLanguage(languageCards, currentLocale);

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
            subtitleStyle: recTheme.textTheme.outlineTileText.copyWith(
              color: recTheme.grayDark3,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 22),
            child: SectionTitleTile('AVAILABLE'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: languageCards.length,
              itemBuilder: (context, index) {
                var languageCard = languageCards[index];
                var isSelectedLocale = languageCard.id == currentLocale.languageCode;

                if (!isSelectedLocale) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GeneralSettingsTile(
                      title: localizations.getLocaleNameByLocaleId(
                        languageCard.id!,
                      ),
                      onTap: () => _changeLanguage(languageCard.id),
                      titleStyle: recTheme.textTheme.outlineTileText.copyWith(
                        fontWeight: FontWeight.w300,
                        color: recTheme.grayDark,
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

  LanguageCardData _getMainLanguage(List<LanguageCardData> languageCards, Locale locale) {
    for (final lang in languageCards) {
      if (lang.id == locale.languageCode) return lang;
    }

    return languageCards[0];
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
