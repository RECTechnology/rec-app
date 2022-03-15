import 'package:flutter/material.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/config/brand.dart';

class SearchInput extends StatefulWidget {
  final TextEditingController? searchController;

  final ValueChanged<String>? fieldChanged;
  final ValueChanged<String>? fieldSubmited;
  final Function()? onFocused;
  final Function()? onUnfocused;

  final String hintText;
  final bool isLoading;
  final bool shaded;
  final double borderRadius;

  const SearchInput({
    Key? key,
    this.searchController,
    this.fieldSubmited,
    this.fieldChanged,
    this.hintText = 'SEARCH',
    this.onFocused,
    this.onUnfocused,
    this.isLoading = false,
    this.shaded = false,
    this.borderRadius = 6,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchInput();
  }
}

class _SearchInput extends State<SearchInput> {
  final TextEditingController _selfController = TextEditingController();
  final FocusNode _focus = FocusNode();

  String _searchInputText = '';

  TextEditingController get controller =>
      widget.searchController ?? _selfController;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focus.hasFocus && widget.onFocused != null) {
      widget.onFocused!();
      return;
    } else if (widget.onUnfocused != null) {
      widget.onUnfocused!();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.shaded
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: Offset(1, 1), // Shadow position
                ),
              ],
            )
          : null,
      child: TextFormField(
        focusNode: _focus,
        controller: controller,
        onChanged: (s) {
          setState(() => _searchInputText = s);
          if (widget.fieldChanged != null) widget.fieldChanged!(s);
        },
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (s) {
          setState(() => _searchInputText = s);
          if (widget.fieldSubmited != null) widget.fieldSubmited!(s);
        },
        decoration: _getDecoration(),
      ),
    );
  }

  void _clearSearch() {
    setState(() => _searchInputText = '');
    controller.text = '';
    if (widget.fieldChanged != null) widget.fieldChanged!('');
    if (widget.fieldSubmited != null) widget.fieldSubmited!('');
    _focus.unfocus();
  }

  InputDecoration _getDecoration() {
    var localizations = AppLocalizations.of(context);
    var suffixIcon = widget.isLoading
        ? SizedBox(
            height: 10,
            width: 10,
            child: Transform.scale(
              scale: 0.5,
              child: CircularProgressIndicator(),
            ),
          )
        : _searchInputText.isNotEmpty
            ? InkWell(
                onTap: _clearSearch,
                child: Icon(
                  Icons.close,
                  color: Brand.grayDark,
                  size: 14,
                ),
              )
            : null;

    return InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      fillColor: Colors.white,
      focusColor: Colors.white,
      hoverColor: Colors.white,
      hintText: localizations!.translate(widget.hintText),
      prefixIcon: Icon(Icons.search, color: Brand.grayDark),
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.only(
        left: 15,
        bottom: 11,
        top: 14,
        right: 15,
      ),
    );
  }
}
