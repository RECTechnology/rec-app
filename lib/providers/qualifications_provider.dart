import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class QualificationsProvider extends ChangeNotifier {
  final QualificationsService _service;

  List<Qualification>? _pendingQualifications = [];
  bool isLoading = false;

  List<Qualification>? get pendingQualifications => _pendingQualifications;

  QualificationsProvider({
    QualificationsService? service,
  }) : _service = service ?? QualificationsService(env: env);

  Future<List<Qualification>> loadPending() async {
    isLoading = true;

    final qualificationList = await getQualifications(Qualification.STATUS_PENDING);
    _pendingQualifications = qualificationList.items;

    isLoading = false;
    notifyListeners();

    return _pendingQualifications ?? [];
  }

  Future<ApiListResponse<Qualification>> getQualifications(String status) {
    return _service.list(
      QualificationSearchData(status: status),
    );
  }

  Future<dynamic> updateQualification(String id, UpdateQualificationData data) {
    return _service.updateQualification(id, data);
  }

  static QualificationsProvider of(context, {bool listen = true}) {
    return Provider.of<QualificationsProvider>(context, listen: listen);
  }

  static QualificationsProvider deaf(context) {
    return of(context, listen: false);
  }

  static ChangeNotifierProvider<QualificationsProvider> getProvider(QualificationsService service) {
    return ChangeNotifierProvider(
      create: (context) => QualificationsProvider(
        service: service,
      ),
    );
  }
}
