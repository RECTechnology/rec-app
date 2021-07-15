import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/SelectableChip.dart';
import 'package:rec/Entities/Forms/RecFilterData.dart';

class RecFilters extends StatefulWidget {
  final List<RecFilterData> filterData;
  final Function(Map<String, bool>) onChanged;

  RecFilters({
    Key key,
    @required this.filterData,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _RecFiltersState createState() => _RecFiltersState();
}

class _RecFiltersState extends State<RecFilters> {
  Map<String, bool> filters = {};
  bool isPressed = false;

  @override
  void initState() {
    widget.filterData.forEach((filter) {
      filters[filter.id] = filter.defaultValue;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.filterData.length,
              itemBuilder: (context, index) {
                var filter = widget.filterData[index];

                return SelectableChip(
                  label: filter.label,
                  isSelected: filters[filter.id],
                  onSelected: (c) {
                    filters[filter.id] = !filters[filter.id];
                    widget.onChanged(filters);
                    setState(() {});
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
