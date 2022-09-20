import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/LimitAndVerification/UploadDocument/UploadDocument.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class DocumentListTile extends StatefulWidget {
  final Document document;
  final Function(Document document, String contentUrl) onCreateDocument;
  final Function(Document document, String contentUrl) onUpdateDocument;

  DocumentListTile(
    this.document, {
    Key? key,
    required this.onCreateDocument,
    required this.onUpdateDocument,
  }) : super(key: key);

  @override
  _DocumentListTileState createState() => _DocumentListTileState();
}

class _DocumentListTileState extends State<DocumentListTile> {
  Document get document => widget.document;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recTheme = RecTheme.of(context);
    final localizations = AppLocalizations.of(context);

    final status = localizations!.translate(document.status);
    final title = localizations.translate(document.kind!.name!);
    final statusTextPart = ': ${document.statusText}';
    final subtitle =
        document.isUnsubmitted
        ? null
        : '$status${document.hasStatusText ? statusTextPart : ''}';

    final ganGoForwards = !(document.isSubmitted || document.isApproved);
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
      icon: icon,
      subtitleStyle: theme.textTheme.caption!.copyWith(
        fontWeight: FontWeight.w400,
        color: recTheme!.documentColorStatus(document.status),
      ),
      titleStyle: theme.textTheme.subtitle1!.copyWith(
        fontWeight: FontWeight.w500,
        color: recTheme.grayDark,
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
