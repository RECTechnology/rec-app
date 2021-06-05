import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Services/DocumentsService.dart';
import 'package:rec/Entities/Document.ent.dart';
import 'package:rec/Entities/DocumentKind.ent.dart';

class DocumentsProvider extends ChangeNotifier {
  final DocumentsService _documentService;

  List<Document> allDocuments = [];
  List<Document> requiredDocuments = [];
  List<Document> pendingOrValidDocuments = [];

  List<DocumentKind> _documentKinds = [];
  List<Document> _documents = [];

  bool isLoading = false;

  DocumentsProvider({DocumentsService documentsService})
      : _documentService = documentsService ?? DocumentsService();

  Future<void> load() async {
    // Prevents doing more requests than needed
    if (isLoading) return;

    isLoading = true;

    _documentKinds = await _getKinds();
    _documents = await _getDocuments() ?? [];

    var allDocuments = _documentKinds.map((kind) {
      // Try to get the document for this kind from the list of sent documents,
      // if it's not found, we create an unsubmitted document for this kind
      return _documents.firstWhere(
        (element) => element.kind.id == kind.id,
        orElse: () => Document(kind: kind),
      );
    }).toList();

    setDocuments(allDocuments);
    notifyListeners();
  }

  void setDocuments(List<Document> allDocuments) {
    this.allDocuments = allDocuments;
    processRequiredDocuments();
    processPendingDocuments();

    isLoading = false;
  }

  void processRequiredDocuments() {
    requiredDocuments = allDocuments
        .where(
          (element) => element.needsUploading,
        )
        .toList();
  }

  void processPendingDocuments() {
    pendingOrValidDocuments = allDocuments
        .where(
          (element) => !element.needsUploading,
        )
        .toList();
  }

  Future<List<DocumentKind>> _getKinds() {
    return _documentService.listKinds().then(
          (value) => value.items
              .where(
                (element) => element.isUserDocument,
              )
              .toList(),
        );
  }

  Future<List<Document>> _getDocuments() {
    return _documentService.list().then((value) => value.items);
  }

  static DocumentsProvider of(context, {bool listen = true}) {
    return Provider.of<DocumentsProvider>(context, listen: listen);
  }

  static ChangeNotifierProvider<DocumentsProvider> getProvider() {
    return ChangeNotifierProvider(
      create: (context) => DocumentsProvider(),
    );
  }
}
