import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Entities/IdiomCard.ent.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/app.dart';
import 'package:rec/brand.dart';

class ChangeLanguagePage extends StatefulWidget {
  ChangeLanguagePage({Key key}) : super(key: key);

  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  List<IdiomCard> languageCards = [
    IdiomCard(
      id: 'es',
      image: AssetImage('assets/flag-es.png'),
    ),
    IdiomCard(
      id: 'en',
      image: AssetImage('assets/flag-en.png'),
    ),
    IdiomCard(
      id: 'ca',
      image: AssetImage('assets/flag-cat.png'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var getMainIdiom = getMainLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(context, title: localizations.translate('IDIOM')),
      body: Scrollbar(
        thickness: 8,
        showTrackOnHover: true,
        radius: Radius.circular(3),
        child: ListView(
          children: [
            GeneralSettingsTile(
              title: localizations.getLocaleNameByLocaleId(getMainIdiom.id),
              subtitle: localizations.translate('MAIN_LANGUAGE'),
              circleAvatar: CircleAvatarRec(
                radius: 27,
                image: getMainIdiom.image,
              ),
              titleStyle: TextStyles.outlineTileText.copyWith(
                fontWeight: FontWeight.w500,
                color: Brand.grayDark,
              ),
              subtitleStyle: TextStyles.outlineTileText.copyWith(
                fontWeight: FontWeight.w400,
                color: Brand.graySubtitle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 22,
              ),
              child: SectionTitleTile(localizations.translate('AVARIABLE')),
            ),
            Container(
              width: 400,
              height: 300,
              child: ListView.builder(
                itemCount: languageCards.length,
                itemBuilder: (context, index) {
                  print('locale: ${localizations.locale.languageCode}');
                  print('list lang: ${languageCards[index].id}');

                  var isSelectedLocale = languageCards[index].id ==
                      localizations.locale.languageCode;

                  if (!isSelectedLocale) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GeneralSettingsTile(
                        title: localizations.getLocaleNameByLocaleId(
                          languageCards[index].id,
                        ),
                        onTap: () {
                          changeIdiom(languageCards[index].id);
                        },
                        titleStyle: TextStyles.outlineTileText.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Brand.grayDark,
                        ),
                        circleAvatar: CircleAvatarRec(
                          radius: 27,
                          image: languageCards[index].image,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }

  // ignore: missing_return
  IdiomCard getMainLanguage() {
    var localizations = AppLocalizations.of(context);

    for (var idiom in languageCards) {
      if (idiom.id == localizations.locale.languageCode) return idiom;
    }

    return languageCards[0];
  }

  void changeIdiom(String locale) {
    Loading.show();

    var userService = UsersService();
    RecSecureStorage().write(
      key: 'locale',
      value: locale,
    );
    setState(() {
      userService.changeIdiom(locale).then((value) {
        Loading.dismiss();
        RecApp.setLocale(context, Locale(locale, locale));
        Navigator.of(context).pop();
      }).onError((error, stackTrace) {
        Loading.dismiss();
        RecToast.showError(context, error.message);
      });
    });
  }
}
