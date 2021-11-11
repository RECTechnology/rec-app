import 'package:flutter/material.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Entities/Forms/LanguageCardData.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/app.dart';
import 'package:rec/brand.dart';

class ChangeLanguagePage extends StatefulWidget {
  ChangeLanguagePage({Key key}) : super(key: key);

  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  final _userService = UsersService();
  final _languageCards = [
    LanguageCardData(
      id: 'es',
      image: AssetImage('assets/flag-es.png'),
    ),
    LanguageCardData(
      id: 'en',
      image: AssetImage('assets/flag-en.png'),
    ),
    LanguageCardData(
      id: 'ca',
      image: AssetImage('assets/flag-cat.png'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var currentLocale = localizations.locale;
    var mainLanguage = _getMainLanguage();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(context, title: 'LANGUAGE'),
      body: Column(
        children: [
          GeneralSettingsTile(
            title: localizations.getLocaleNameByLocaleId(mainLanguage.id),
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
                var isSelectedLocale =
                    languageCard.id == currentLocale.languageCode;

                if (!isSelectedLocale) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GeneralSettingsTile(
                      title: localizations.getLocaleNameByLocaleId(
                        languageCard.id,
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
      if (lang.id == localizations.locale.languageCode) return lang;
    }

    return _languageCards[0];
  }

  void _changeLanguage(String locale) {
    Loading.show();

    _userService.changeLanguage(locale).then((value) {
      RecApp.setLocale(context, Locale(locale, locale));
      Loading.dismiss();
      Navigator.of(context).pop();
    }).catchError(_onError);

    setState(() {});
  }

  void _onError(error) {
    Loading.dismiss();
    RecToast.showError(context, error.message);
  }
}
