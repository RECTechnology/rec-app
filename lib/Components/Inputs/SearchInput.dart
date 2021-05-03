import 'package:flutter/material.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class SearchInput extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String search) fieldChanged;
  final Function(String search) fieldSubmited;
  final String hintText;

  const SearchInput({
    Key key,
    TextEditingController searchController,
    this.fieldSubmited,
    this.fieldChanged,
    this.hintText = 'SEARCH',
  })  : searchController = searchController,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchInput();
  }
}

class _SearchInput extends State<SearchInput> {
  final TextEditingController _selfController = TextEditingController();
  String _searchInputText = '';

  TextEditingController get controller =>
      widget.searchController ?? _selfController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: Container(
          color: Colors.white,
          child: TextFormField(
            controller: controller,
            onChanged: (s) {
              setState(() => _searchInputText = s);
              if (widget.fieldChanged != null) widget.fieldChanged(s);
            },
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (s) {
              setState(() => _searchInputText = s);
              if (widget.fieldSubmited != null) widget.fieldSubmited(s);
            },
            decoration: _getDecoration(),
          ),
        ),
      ),
    );
  }

  void _clearSearch() {
    setState(() => _searchInputText = '');
    controller.text = '';
    if (widget.fieldChanged != null) widget.fieldChanged('');
    if (widget.fieldSubmited != null) widget.fieldSubmited('');
  }

  InputDecoration _getDecoration() {
    var localizations = AppLocalizations.of(context);

    return InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      fillColor: Colors.white,
      focusColor: Colors.white,
      hoverColor: Colors.white,
      hintText: localizations.translate(widget.hintText),
      prefixIcon: Icon(Icons.search, color: Brand.grayDark),
      suffixIcon: _searchInputText.isNotEmpty
          ? InkWell(
              onTap: _clearSearch,
              child: Icon(
                Icons.close,
                color: Brand.grayDark,
                size: 14,
              ),
            )
          : null,
      contentPadding: EdgeInsets.only(
        left: 15,
        bottom: 11,
        top: 14,
        right: 15,
      ),
    );
  }
}
