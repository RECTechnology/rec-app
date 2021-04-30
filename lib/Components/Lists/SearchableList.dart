import 'package:flutter/material.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/Components/Inputs/SearchInput.dart';

class SearchableList<T> extends StatefulWidget {
  final List<Widget> items;
  final Function(String query) search;
  final String searchHintText;
  final Widget noItemsWidget;
  final bool isLoading;

  const SearchableList({
    Key key,
    @required this.items,
    @required this.search,
    this.searchHintText = 'SEARCH',
    this.noItemsWidget,
    this.isLoading = false,
  }) : super(key: key);

  @override
  _SearchableList createState() => _SearchableList();
}

class _SearchableList extends State<SearchableList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchInput(
          hintText: widget.searchHintText,
          fieldChanged: (s) {
            widget.search(s);
          },
          fieldSubmited: (s) {
            widget.search(s);
          },
        ),
        Expanded(
          flex: 4,
          child: widget.items != null && widget.items.isNotEmpty
              ? ListView(children: widget.items)
              : widget.isLoading
                  ? LoadingIndicator()
                  : widget.noItemsWidget,
        ),
      ],
    );
  }
}
