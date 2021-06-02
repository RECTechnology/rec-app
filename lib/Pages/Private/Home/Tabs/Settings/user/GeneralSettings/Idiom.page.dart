import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Entities/IdiomCard.ent.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/app.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class IdiomPage extends StatefulWidget {
  IdiomPage({Key key}) : super(key: key);

  @override
  _IdiomPageState createState() => _IdiomPageState();
}

class _IdiomPageState extends State<IdiomPage> {
  var idiomCards = <IdiomCard>[
    IdiomCard(
      id: 'es',
      image: AssetImage('assets/bandera-española.png'),
    ),
    IdiomCard(
      id: 'en',
      image: AssetImage('assets/bandera-inglesa.png'),
    ),
    IdiomCard(
      id: 'ca',
      image: AssetImage('assets/bandera-catalana.png'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

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
              title: localizations.getNameByLocaleId(getMainIdiom().id),
              subtitle: localizations.translate('MAIN_IDIOM'),
              circleAvatar: CircleAvatarRec(
                radius: 27,
                image: getMainIdiom().image,
              ),
              textStyle: TextStyles.outlineTileText.copyWith(
                fontWeight: FontWeight.w500,
                color: Brand.grayDark,
              ),
              subtitleTextStyle: TextStyles.outlineTileText.copyWith(
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
                itemCount: idiomCards.length,
                itemBuilder: (context, index) {
                  if (idiomCards[index].id !=
                      localizations.locale.languageCode) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GeneralSettingsTile(
                        title: localizations
                            .getNameByLocaleId(idiomCards[index].id),
                        onTap: () {
                          changeIdiom(idiomCards[index].id);
                        },
                        textStyle: TextStyles.outlineTileText.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Brand.grayDark,
                        ),
                        circleAvatar: CircleAvatarRec(
                          radius: 27,
                          image: idiomCards[index].image,
                        ),
                      ),
                    );
                  }
                  return null;
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
  IdiomCard getMainIdiom() {
    var localizations = AppLocalizations.of(context);

    for (var idiom in idiomCards) {
      if (idiom.id == localizations.locale.languageCode) return idiom;
    }
  }

  void changeIdiom(String id) {
    var userService = UsersService();

    setState(() {
      userService.changeIdiom(id).then((value) {
        Navigator.of(context).pushReplacementNamed(Routes.home);
        RecApp.setLocale(context, Locale(id, id.toUpperCase()));
      });
    });
  }
}
