import 'package:rec/Entities/Account.ent.dart';

class SortDir {
  static const String asc = 'ASC';
  static const String desc = 'DESC';
}

class MapSearchData {
  bool onMap = true;
  bool onlyWithOffers = false;

  String search = '';
  String type = Account.TYPE_COMPANY;
  String subType = '';
  String sort = 'name';
  String order = SortDir.desc;

  String campaign = '1';

  int limit = 300;
  int offset = 0;

  MapSearchData({
    this.search = '',
    this.onMap = true,
    this.onlyWithOffers = false,
    this.type = Account.TYPE_COMPANY,
    this.subType = '',
    this.limit = 300,
    this.offset = 0,
    this.sort = 'name',
    this.order = SortDir.desc,
  });

  Map<String, dynamic> toJson() {
    return {
      'offset': '$offset',
      'limit': '$limit',
      'sort': '$sort',
      'order': '$order',
      'search': '$search',
      'only_with_offers': '$onlyWithOffers',
      'campaigns': '$campaign',
      'type': type,
      'subtype': subType,
    };
  }
}
