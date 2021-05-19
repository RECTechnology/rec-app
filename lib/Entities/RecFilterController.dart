import 'package:rec/Entities/RecFilterData.dart';

class RecFilterController {
  final Map<String, bool> _filters = {};
  final List<RecFilterData> filterDefinitions = [];
  final Function onChanged;

  RecFilterController({
    this.onChanged,
  });

  bool get hasAnyFilter {
    return _filters.values.where((element) => element == true).isNotEmpty;
  }

  RecFilterController add(RecFilterData filter) {
    filterDefinitions.add(filter);
    _filters[filter.id] = filter.defaultValue;

    return this;
  }

  dynamic getValueById(String id) {
    return _filters[id];
  }

  dynamic getValueByFilterData(RecFilterData filter) {
    return _filters[filter.id];
  }

  RecFilterController setValueFromId(String id, dynamic value) {
    _filters[id] = value;
    return this;
  }

  RecFilterController setValueFromFilter(RecFilterData filter, dynamic value) {
    _filters[filter.id] = value;
    return this;
  }
}
