import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/connecta/add_product.dialog.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/connecta/product_list.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/All.dart';
import 'package:rec/providers/product_provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ConnectaConsumingPage extends StatefulWidget {
  ConnectaConsumingPage({Key? key}) : super(key: key);

  @override
  State<ConnectaConsumingPage> createState() => _ConnectaConsumingPageState();
}

class _ConnectaConsumingPageState extends State<ConnectaConsumingPage> {
  List<Product> selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    final account = UserState.of(context).account;
    final products = account?.consumingProducts ?? [];
    return Scaffold(
      appBar: EmptyAppBar(context, title: 'CONSUMING'),
      body: ConnectaProductList(
        products: products,
        onAddAction: _addProduct,
        onRemoveAction: _removeProducts,
      ),
    );
  }

  void _removeProducts(selectedProducts) async {
    final provider = ProductProvider.deaf(context);
    final userState = UserState.deaf(context);

    Loading.show();
    for (var product in selectedProducts) {
      await provider.removeProduct(userState.account!.id!, product.id, ProductType.consuming);
    }
    await UserState.deaf(context).getUser();
    Loading.dismiss();
    RecToast.showSuccess(context, 'REMOVED_PRODUCTS');
  }

  _addProduct() {
    final provider = ProductProvider.deaf(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        clipBehavior: Clip.hardEdge,
        insetPadding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: AddProductContent(
          addProduct: (value) {
            return provider.addProduct(value, ProductType.consuming);
          },
        ),
      ),
    );
  }
}
