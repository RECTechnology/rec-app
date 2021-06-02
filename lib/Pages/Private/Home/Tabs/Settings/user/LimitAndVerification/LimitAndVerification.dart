import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Services/DocumentsService.dart';
import 'package:rec/Components/ListTiles/DocumentListTile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Entities/Document.ent.dart';
import 'package:rec/Entities/DocumentKind.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class LimitAndVerificationPage extends StatefulWidget {
  LimitAndVerificationPage({Key key}) : super(key: key);

  @override
  _LimitAndVerificationState createState() => _LimitAndVerificationState();
}

class _LimitAndVerificationState extends State<LimitAndVerificationPage> {
  final DocumentsService _documentService = DocumentsService();

  final List<Document> _allDocuments = [
    Document(
      kind: DocumentKind(name: 'test1'),
      status: Document.STATUS_DECLINED,
      statusText: 'La imagen es mierda',
    ),
    Document(
      kind: DocumentKind(name: 'test2'),
      status: Document.STATUS_SUBMITTED,
    ),
    Document(
      kind: DocumentKind(name: 'test3'),
      status: Document.STATUS_APPROVED,
    ),
  ];
  List<Document> get _requiredDocuments => _allDocuments
      .where(
        (element) => element.isUnsubmitted || element.isDeclined,
      )
      .toList();
  List<Document> get _pendingOrValidDocuments => _allDocuments
      .where(
        (element) => element.isSubmitted || element.isApproved,
      )
      .toList();

  // List<DocumentKind> _documentKinds = [];

  @override
  void initState() {
    super.initState();
    _getKinds();
  }

  Future _getKinds() {
    return _documentService.listKinds().then((value) {
      // setState(() {
      //   _documentKinds = value.items;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Brand.defaultAvatarBackground,
      appBar: EmptyAppBar(context, title: 'SETTINGS_USER_LIMITS'),
      body: Scrollbar(
        thickness: 8,
        showTrackOnHover: true,
        radius: Radius.circular(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.translate('SEND_REC_LIMIT', params: {
                      'amount': 300,
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
                localizations.translate('REQUIRED_DOCUMENTS'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Brand.grayDark4,
                ),
              ),
            ),
            Expanded(
              child: _requiredDocuments.isEmpty
                  ? ListView(children: [_noDocumentTile()])
                  : ListView.builder(
                      itemCount: _requiredDocuments.length,
                      itemBuilder: _buildRequiredDocumentTile,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                localizations.translate('PENDING_DOCUMENTS'),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Brand.grayDark4),
              ),
            ),
            Expanded(
              child: _pendingOrValidDocuments.isEmpty
                  ? ListView(children: [_noDocumentTile()])
                  : ListView.builder(
                      itemCount: _pendingOrValidDocuments.length,
                      itemBuilder: _buildPendingDocumentTile,
                    ),
            ),
          ],
        ),
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

  Widget _buildRequiredDocumentTile(context, index) {
    return DocumentListTile(_requiredDocuments[index]);
  }

  Widget _buildPendingDocumentTile(context, index) {
    return DocumentListTile(_pendingOrValidDocuments[index]);
  }
}
