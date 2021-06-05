import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Interfaces/ApiListResponse.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Document.ent.dart';
import 'package:rec/Entities/DocumentKind.ent.dart';
import 'package:rec/Entities/Forms/CreateDocumentData.dart';

/// This service is in charge of all requests related to [Documents] and [DocumentKinds]
/// Like listing, posting, updating, etc...
///
/// * **Authentication Required** - the user must be authenticated
class DocumentsService extends ServiceBase {
  DocumentsService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  /// List all [DocumentKinds]
  Future<ApiListResponse<DocumentKind>> listKinds() {
    final uri = ApiPaths.documentKinds.withQueryParams({
      'limit': '30',
    }).toUri();

    return this.get(uri).then(_mapKinds);
  }

  /// List all [Documents] for the authenticated user
  Future<ApiListResponse<Document>> list() {
    final uri = ApiPaths.documents.toUri();

    return this.get(uri).then(_mapDocuments);
  }

  /// Creates a document for the current authenticated user
  Future createDocument(CreateDocumentData data) {
    final uri = ApiPaths.documents.toUri();

    return this.post(uri, data.toJson());
  }

  /// Update a document instance
  /// For now, only content can be updated
  Future updateDocument(String documentId, {@required String content}) {
    final uri = ApiPaths.documents.append(documentId).toUri();

    return this.put(uri, {'content': content});
  }

  // TODO: Refactor this, as it's beeing used quite often, and repeated
  ApiListResponse<DocumentKind> _mapKinds(
    Map<String, dynamic> data,
  ) {
    return ApiListResponse.fromJson(
      data['data'],
      mapper: (el) => DocumentKind.fromJson(el),
    );
  }

  ApiListResponse<Document> _mapDocuments(
    Map<String, dynamic> data,
  ) {
    return ApiListResponse.fromJson(
      {'elements': data['data']},
      mapper: (el) => Document.fromJson(el),
    );
  }
}
