import 'package:flutter/material.dart';
import 'package:rec/Components/ListTiles/custom_checkbox_listtile.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/providers/All.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ConnectaProductList extends StatefulWidget {
  final List<Product> products;
  final VoidCallback onAddAction;
  final ValueChanged<List<Product>> onRemoveAction;

  ConnectaProductList({
    Key? key,
    required this.products,
    required this.onAddAction,
    required this.onRemoveAction,
  }) : super(key: key);

  @override
  State<ConnectaProductList> createState() => _ConnectaProductListState();
}

class _ConnectaProductListState extends State<ConnectaProductList> {
  List<Product> selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(),
        Expanded(
          child: _list(),
        ),
      ],
    );
  }

  _header() {
    final account = UserState.of(context).account;
    final theme = RecTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocalizedText(
                  account?.name ?? 'PARTICULAR',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 12),
                LocalizedText(
                  'PRODUCTS_SERVICES',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _actionButton(theme),
        ],
      ),
    );
  }

  CircleAvatar _actionButton(RecThemeData? theme) {
    if (selectedProducts.isNotEmpty) {
      return CircleAvatar(
        radius: 30,
        backgroundColor: theme?.red,
        child: IconButton(
          icon: Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
          onPressed: () {
            widget.onRemoveAction(selectedProducts.toList());
            selectedProducts.clear();
            setState(() {});
          },
        ),
      );
    }
    return CircleAvatar(
      radius: 30,
      backgroundColor: theme?.green3,
      child: IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: widget.onAddAction,
      ),
    );
  }

  _list() {
    final products = widget.products;
    final locale = AppLocalizations.of(context)?.locale;
    if (products.isEmpty) {
      return ListView(
        children: [
          ListTile(
            title: LocalizedText('NO_ITEMS'),
          )
        ],
      );
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final item = products[index];
        return CustomCheckboxTile(
          selected: selectedProducts.contains(item),
          onChanged: (value) {
            if (value == false) {
              selectedProducts.remove(item);
            } else {
              selectedProducts.add(item);
            }
            setState(() {});
          },
          backgroundColor: index % 2 == 1 ? Colors.white : Colors.grey[200],
          title: item.getNameForLocale(locale!) ?? item.name,
        );
      },
    );
  }
}
