import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/boxes.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/config/themes/rec.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/providers/product_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AddProductContent extends StatefulWidget {
  final Future Function(String productName) addProduct;
  AddProductContent({Key? key, required this.addProduct}) : super(key: key);

  @override
  State<AddProductContent> createState() => _AddProductContentState();
}

class _AddProductContentState extends State<AddProductContent> {
  ProductProvider? provider;
  List<Product> results = [];
  String searchQuery = '';
  final controller = TextEditingController();

  bool loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provider == null) {
      provider = ProductProvider.of(context);
      _load();
    }
  }

  @override
  void dispose() {
    EasyDebounce.cancel('search_products');
    super.dispose();
  }

  _load() async {
    loading = true;
    setState(() {});
    await provider?.load(search: searchQuery);
    results = (provider?.products ?? []).where((element) => element.hasValues).toList();
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LocalizedText('ADD_PRODUCT_SERVICE'),
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: RecTheme.of(context)?.grayDark,
        actions: [
          IconButton(
            splashRadius: 24,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0).copyWith(top: 0),
          child: Column(
            children: [
              LocalizedText(
                'ADD_PRODUCT_DESC',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Stack(
                  children: [
                    GrayBox(
                      height: null,
                      child: Column(
                        children: [
                          _search(),
                          const SizedBox(height: 8),
                          Expanded(child: _resultsList()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              RecActionButton(
                label: 'ADD',
                backgroundColor: recTheme.green3,
                // Only enable button if something is written in the search field
                onPressed: searchQuery.isEmpty
                    ? null
                    : () async {
                        Loading.show();
                        try {
                          await widget.addProduct(searchQuery);
                          searchQuery = '';
                          controller.text = '';
                          setState(() {});
                          await UserState.deaf(context).getUser();
                          await _load();
                          RecToast.showInfo(context, 'ADDED_PRODUCT_OK');
                        } catch (e) {
                          RecToast.showInfo(context, e.toString());
                        }
                        Loading.dismiss();
                      },
              ),
              SizedBox(height: 64)
            ],
          ),
        ),
      ),
    );
  }

  _search() {
    return Container(
      height: 60,
      child: Stack(
        children: [
          if (loading)
            Positioned(
              child: SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                width: 20,
                height: 20,
              ),
              right: 8,
              top: 30,
            ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Nombre'),
            controller: controller,
            autofocus: true,
            onChanged: (val) {
              searchQuery = val;
              setState(() {});
              EasyDebounce.debounce(
                'search_products',
                Duration(milliseconds: 300),
                () => _load(),
              );
            },
          ),
        ],
      ),
    );
  }

  _resultsList() {
    final locale = AppLocalizations.of(context)?.locale;

    if (results.isEmpty && provider?.isLoading != true) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: LocalizedText('NO_ITEMS'),
      );
    }

    if (results.isEmpty && provider?.isLoading == true) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return ListView.separated(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return InkWell(
          onTap: () {
            final resultName = (result.getNameForLocale(locale!) ?? result.name).toLowerCase();
            searchQuery = resultName;
            controller.text = resultName;
            setState(() {});
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: _buildResult(result),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 1,
          color: RecTheme.of(context)?.grayLight3,
        );
      },
    );
  }

  _buildResult(Product result) {
    final locale = AppLocalizations.of(context)?.locale;
    final resultName = (result.getNameForLocale(locale!) ?? result.name).toLowerCase();
    if (searchQuery.isEmpty || resultName.isEmpty) return Text(resultName);

    final indexOfQueryMatch = resultName.indexOf(searchQuery.toLowerCase());
    if (indexOfQueryMatch < 0) return Text(resultName);

    final beforeMatch = resultName.substring(0, indexOfQueryMatch);
    final match = resultName.substring(indexOfQueryMatch, indexOfQueryMatch + searchQuery.length);
    final afterMatch = resultName.substring(
      indexOfQueryMatch + searchQuery.length,
      resultName.length,
    );

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(text: beforeMatch),
          TextSpan(text: match, style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: afterMatch),
        ],
      ),
    );
  }
}
