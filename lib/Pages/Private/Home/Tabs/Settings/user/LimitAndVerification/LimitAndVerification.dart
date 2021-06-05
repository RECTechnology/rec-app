import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Services/DocumentsService.dart';
import 'package:rec/Components/ListTiles/DocumentListTile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Entities/Document.ent.dart';
import 'package:rec/Entities/Forms/CreateDocumentData.dart';
import 'package:rec/Entities/Level.ent.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/DocumentsProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';
import 'package:rec/preferences.dart';

class LimitAndVerificationPage extends StatefulWidget {
  final bool pollDocuments;

  LimitAndVerificationPage({
    Key key,
    this.pollDocuments = true,
  }) : super(key: key);

  @override
  _LimitAndVerificationState createState() => _LimitAndVerificationState();
}

class _LimitAndVerificationState extends State<LimitAndVerificationPage> {
  final DocumentsService _documentService = DocumentsService();
  DocumentsProvider _documentsProvider;
  Timer _documentsPollTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _documentsProvider ??= DocumentsProvider.of(context);
    if (widget.pollDocuments) _documentsPollTimer ??= _documentsTimer();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _documentsPollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var userState = UserState.of(context);
    var localizations = AppLocalizations.of(context);
    var documentsProvider = DocumentsProvider.of(context);
    var unlimitedLimitText = localizations.translate('NO_LIMIT');
    var isKyc2 = userState.user.anyAccountAtLevel(Level.CODE_KYC2);

    // This simulates that documents are validated
    // If user is KYC2 it means it has been validated previously
    // But, if a document is denied or expired, user must re-upload documents
    //
    // This set's the status of non-submitted documents as if they where approved
    // NOTE: This is not the ideal place, but needed to get this moving
    documentsProvider.setDocuments(
      documentsProvider.allDocuments.map((element) {
        if (isKyc2 && element.isUnsubmitted) {
          element.status = Document.STATUS_APPROVED;
        }

        return element;
      }).toList(),
    );

    var requiredDocs = documentsProvider.requiredDocuments;
    var pendingDocs = documentsProvider.pendingOrValidDocuments;

    return Scaffold(
      backgroundColor: Brand.defaultAvatarBackground,
      appBar: EmptyAppBar(context, title: 'SETTINGS_USER_LIMITS'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('SEND_REC_LIMIT', params: {
                    'amount': userState.account.level.maxOut != null
                        ? '${userState.account.level.maxOut}R'
                        : unlimitedLimitText,
                  }),
                  style: theme.textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Brand.detailsTextColor),
                ),
                const SizedBox(height: 16),
                Text(
                  localizations.translate('LIMITS_DESC'),
                  style: theme.textTheme.caption,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              localizations.translate('REQUIRED_DOCUMENTS') +
                  ' (${requiredDocs.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Brand.grayDark4,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: documentsProvider.load,
              child: requiredDocs.isEmpty
                  ? ListView(children: [_noDocumentTile()])
                  : Scrollbar(
                      child: ListView.builder(
                        itemCount: requiredDocs.length,
                        itemBuilder: (context, index) => _buildDocumentTile(
                          requiredDocs[index],
                        ),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              localizations.translate('PENDING_DOCUMENTS') +
                  ' (${pendingDocs.length})',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Brand.grayDark4),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: documentsProvider.load,
              child: pendingDocs.isEmpty
                  ? ListView(children: [_noDocumentTile()])
                  : Scrollbar(
                      child: ListView.builder(
                        itemCount: pendingDocs.length,
                        itemBuilder: (context, index) => _buildDocumentTile(
                          pendingDocs[index],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noDocumentTile() {
    var localizations = AppLocalizations.of(context);

    return GeneralSettingsTile(
      title: localizations.translate('NO_DOCUMENT'),
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Brand.grayDark4,
      ),
    );
  }

  Widget _buildDocumentTile(document) {
    return DocumentListTile(
      document,
      onCreateDocument: _createDocument,
      onUpdateDocument: _editDocument,
    );
  }

  Future _editDocument(Document document, String docContentUrl) {
    Loading.show();

    return _documentService
        .updateDocument(
          document.id,
          content: docContentUrl,
        )
        .then((value) => _createDocumentOk(value, document))
        .catchError(_onError);
  }

  Future _createDocument(Document document, String docContentUrl) {
    var userState = UserState.of(context, listen: false);
    Loading.show();

    return _documentService
        .createDocument(
          CreateDocumentData(
            content: docContentUrl,
            kind_id: document.kind.id,
            name: Document.createDocName(
              document,
              userState.user,
            ),
          ),
        )
        .then((value) => _createDocumentOk(value, document))
        .catchError(_onError);
  }

  FutureOr _onError(error) {
    Loading.dismiss();
    RecToast.showError(context, error.message);
  }

  FutureOr _createDocumentOk(value, Document document) async {
    await Loading.dismiss();
    RecToast.showSuccess(context, 'DOCUMENT_SUBMITTED_CORRECTLY');

    var documentsProvider = DocumentsProvider.of(context, listen: false);
    await documentsProvider.load();
  }

  Timer _documentsTimer() {
    return Timer.periodic(
      Preferences.documentsRefreshInterval,
      (_) {
        _documentsProvider?.load();
      },
    );
  }
}
