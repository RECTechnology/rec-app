import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rec/Entities/Document.ent.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/LimitAndVerification/UploadDocument/UploadDocument.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

import 'GeneralSettingsTile.dart';

class DocumentListTile extends StatefulWidget {
  final Document document;
  final Function(Document document, String contentUrl) onCreateDocument;
  final Function(Document document, String contentUrl) onUpdateDocument;

  DocumentListTile(
    this.document, {
    Key key,
    @required this.onCreateDocument,
    @required this.onUpdateDocument,
  }) : super(key: key);

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
    var subtitle = document.isUnsubmitted
        ? null
        : '$status${document.hasStatusText ? statusTextPart : ''}';

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
      title: title ?? 'Document',
      subtitle: subtitle,
      icon: icon,
      subtitleStyle: theme.textTheme.caption.copyWith(
        fontWeight: FontWeight.w400,
        color: Brand.getColorForDocumentStatus(document.status),
      ),
      titleStyle: theme.textTheme.subtitle1.copyWith(
        fontWeight: FontWeight.w500,
        color: Brand.grayDark,
      ),
      onTap: ganGoForwards ? _goForwards : null,
    );
  }

  Future _goForwards() async {
    var docContentUrl = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (ctx) => UploadDocument(
          document: document,
        ),
      ),
    );

    // No result means upload document did not upload any document
    if (docContentUrl == null) return;

    // If document is unsubmitted we need to create the document
    if (document.isUnsubmitted) {
      return widget.onCreateDocument(document, docContentUrl);
    }

    // If it's already submitted we need tu update it
    return widget.onUpdateDocument(document, docContentUrl);
  }
}
