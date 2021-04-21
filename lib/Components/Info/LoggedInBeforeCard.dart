import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Entities/User.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/BoxDecorations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class LoggedInBeforeCard extends StatefulWidget {
  final User savedUser;
  final Function() onNotYou;

  const LoggedInBeforeCard({Key key, this.savedUser, this.onNotYou})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoggedInBeforeCard();
  }
}

class _LoggedInBeforeCard extends State<LoggedInBeforeCard> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecorations.whiteShadowBox(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatarRec(
                imageUrl: widget.savedUser.image,
                name: widget.savedUser.username,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: Paddings.label,
                  child: Text(
                    localizations.translate('DNI_NIE'),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Padding(
                  padding: Paddings.headline,
                  child: Text(
                    widget.savedUser.username,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                InkWell(
                  onTap: widget.onNotYou,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Brand.primaryColor),
                      text: localizations.translate('NOT_U'),
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
