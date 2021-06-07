import 'package:flutter/material.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class DropDown extends StatefulWidget {
  final List data;
  final Function(String) onSelect;
  final String title;
  final String current;
  final bool isDense;
  final BoxDecoration decoration;
  final EdgeInsets padding;

  DropDown({
    Key key,
    @required this.title,
    this.onSelect,
    this.current = '',
    this.isDense = true,
    List data = const [],
    BoxDecoration decoration,
    EdgeInsets padding,
  })  : data = data ?? [],
        decoration = decoration ??
            const BoxDecoration(
              color: Brand.defaultAvatarBackground,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
        padding = padding ??
            const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
        super(key: key);

  @override
  _DropDownState createState() => _DropDownState(currentValue: current);
}

class _DropDownState extends State<DropDown> {
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String currentValue;

  _DropDownState({
    this.currentValue,
  });

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    var localizations = AppLocalizations.of(context);

    var items = <DropdownMenuItem<String>>[];
    for (String item in widget.data) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(localizations.translate(item)),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    _dropDownMenuItems = getDropDownMenuItems();
    currentValue ??= _dropDownMenuItems[0].value;

    return Container(
      padding: widget.padding,
      decoration: widget.decoration,
      child: DropdownButton<String>(
        isDense: widget.isDense,
        value: currentValue,
        items: _dropDownMenuItems,
        onChanged: widget.onSelect == null
            ? null
            : (value) {
                currentValue = value;
                if (widget.onSelect != null) widget.onSelect(value);
              },
        underline: Container(),
        isExpanded: true,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: Brand.grayDark4),
      ),
    );
  }
}
