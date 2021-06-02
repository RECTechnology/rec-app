import 'package:rec/Entities/DocumentKind.ent.dart';
import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Helpers/Checks.dart';

/// Document entity class defining a document instance
class Document extends Entity {
  static final String STATUS_SUBMITTED = 'rec_submitted';
  static final String STATUS_DECLINED = 'rec_declined';
  static final String STATUS_APPROVED = 'rec_approved';
  static final String STATUS_UNSUBMITTED = 'internal_unsubmitted';

  /// List of all posible statuses
  static final List<String> allStatus = [
    STATUS_SUBMITTED,
    STATUS_DECLINED,
    STATUS_APPROVED,
  ];

  /// Specifies what kind of document this is
  DocumentKind kind;

  /// Holds the status of the Document
  String status;

  /// Gives some information about the status
  String statusText;

  /// Holds the content of the document
  String content;

  Document({
    String id,
    String createdAt,
    String updatedAt,
    String statusText,
    String status,
    this.content,
    this.kind,
  })  : status = status ?? STATUS_UNSUBMITTED,
        statusText = statusText ?? '',
        super(id, createdAt, updatedAt);

  /// Whether this document has any content
  bool get hasContent => Checks.isNotEmpty(content);

  /// Whether this document has statusText
  bool get hasStatusText => Checks.isNotEmpty(statusText);

  /// Whether this document status is DECLINED
  bool get isUnsubmitted => status == STATUS_UNSUBMITTED;

  /// Whether this document status is DECLINED
  bool get isDeclined => status == STATUS_DECLINED;

  /// Whether this document status is SUBMITTED
  bool get isSubmitted => status == STATUS_SUBMITTED;

  /// Whether this document status is APPROVED
  bool get isApproved => status == STATUS_APPROVED;

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      createdAt: json['created'],
      updatedAt: json['updated'],
      content: json['content'],
      status: json['status'],
      statusText: json['status_text'],
      kind: Checks.isNotNull(json['kind'])
          ? DocumentKind.fromJson(json['kind'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
