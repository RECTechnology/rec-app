import 'package:flutter/material.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/Components/Inputs/text_fields/SearchInput.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class SearchableList<T> extends StatefulWidget {
  final List<Widget> items;
  final Function(String query) search;
  final String searchHintText;
  final Widget? noItemsWidget;
  final bool isLoading;

  const SearchableList({
    Key? key,
    required this.items,
    required this.search,
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
          child: Checks.isNotEmpty(widget.items)
              ? ListView(children: widget.items)
              : widget.isLoading
                  ? LoadingIndicator()
                  : widget.noItemsWidget!,
        ),
      ],
    );
  }
}
