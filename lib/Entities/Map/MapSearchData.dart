import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Helpers/SortDir.dart';

class MapSearchData {
  bool onMap = true;
  bool onlyWithOffers;

  String search = '';
  String type = Account.TYPE_COMPANY;
  String subType = '';
  String sort = 'name';
  String order = SortDir.desc;

  int limit = 300;
  int offset = 0;

  MapSearchData({
    this.search,
    this.onMap,
    this.onlyWithOffers,
    this.type,
    this.subType,
    this.limit,
    this.sort,
    this.order,
    this.offset,
  });

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'limit': limit,
      'sort': sort,
      'order': order,
      'query': {
        'search': search,
        'on_map': onMap,
        'only_with_offers': onlyWithOffers,
        'type': type,
        'subtype': subType,
      },
    };
  }
}
