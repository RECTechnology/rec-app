import 'package:flutter/material.dart';
import 'package:rec/Entities/Document.ent.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/LimitAndVerification/UploadDocument/UploadDocument.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

import 'GeneralSettingsTile.dart';

class DocumentStatus extends StatelessWidget {
  final Document document;

  const DocumentStatus(this.document, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var localizedStatus = localizations.translate(document.status);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: localizedStatus),
          TextSpan(text: ': '),
          TextSpan(text: document.statusText),
        ],
      ),
    );
  }
}

class DocumentListTile extends StatefulWidget {
  final Document document;

  DocumentListTile(this.document, {Key key}) : super(key: key);

  @override
  _DocumentListTileState createState() => _DocumentListTileState();
}

class _DocumentListTileState extends State<DocumentListTile> {
  Document get document => widget.document;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var localizations = AppLocalizations.of(context);

    var status = localizations.translate(document.status);
    var title = localizations.translate(document.kind.name);
    var statusTextPart = ': ${document.statusText}';
    var subtitle = '$status${document.hasStatusText ? statusTextPart : ''}';

    var ganGoForwards = !(document.isSubmitted || document.isApproved);
    var icon = ganGoForwards
        ? Icon(
            Icons.arrow_forward_ios,
            size: 20,
          )
        : null;

    if (document.isApproved) {
      icon = Icon(
        Icons.check,
        size: 20,
      );
    }

    return GeneralSettingsTile(
      title: title,
      subtitle: subtitle,
      subtitleTextStyle: theme.textTheme.caption.copyWith(
        fontWeight: FontWeight.w400,
        color: Brand.getColorForDocumentStatus(document.status),
      ),
      icon: icon,
      textStyle: theme.textTheme.subtitle1.copyWith(
        fontWeight: FontWeight.w500,
        color: Brand.grayDark,
      ),
      onTap: ganGoForwards ? _goForwards : null,
    );
  }

  Future _goForwards() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => UploadDocument(
        title: document.kind.name,
      ),
    ));
  }
}
