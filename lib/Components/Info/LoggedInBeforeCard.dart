import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/styles/box_decorations.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class LoggedInBeforeCard extends StatefulWidget {
  final User? savedUser;
  final Function()? onNotYou;

  const LoggedInBeforeCard({Key? key, this.savedUser, this.onNotYou})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoggedInBeforeCard();
  }
}

class _LoggedInBeforeCard extends State<LoggedInBeforeCard> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final recTheme = RecTheme.of(context);

    return Container(
      decoration: BoxDecorations.whiteShadowBox(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatarRec(
                imageUrl: widget.savedUser!.image,
                name: widget.savedUser!.username,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: Paddings.label,
                  child: LocalizedText(
                    'DNI_NIE',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Padding(
                  padding: Paddings.headline,
                  child: Text(
                    widget.savedUser!.username!,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                InkWell(
                  onTap: widget.onNotYou,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: recTheme!.primaryColor),
                      text: localizations!.translate('NOT_U'),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
