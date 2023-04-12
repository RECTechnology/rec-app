import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ProductProvider extends ChangeNotifier {
  final ProductsService _service;
  List<Product>? _products = [];
  bool isLoading = false;

  List<Product>? get products => _products;

  ProductProvider({
    ProductsService? service,
  }) : _service = service ?? ProductsService(env: env);

  Future<List<Product>> load({bool Function(Product activity)? filter, String? search}) async {
    isLoading = true;

    var activitiesListResponse = await _service.list(search: search);
    _products = activitiesListResponse.items;
    _products!.sort((a, b) => a.name.compareTo(b.name));

    if (filter != null) {
      _products = _products?.where(filter).toList();
    }

    isLoading = false;
    notifyListeners();

    return _products ?? [];
  }

  Future addProduct(String name, ProductType type) {
    return _service.addProduct(name, type);
  }

  Future removeProduct(String accountId, String productId, ProductType type) {
    return _service.removeProduct(accountId, productId, type);
  }

  Future<List<Product>> loadOnly([bool Function(Product activity)? filter]) async {
    var activitiesListResponse = await _service.list();
    _products = activitiesListResponse.items;
    _products!.sort((a, b) => a.name.compareTo(b.name));

    if (filter != null) {
      _products = _products?.where(filter).toList();
    }

    return _products ?? [];
  }

  static ProductProvider of(context, {bool listen = true}) {
    return Provider.of<ProductProvider>(
      context,
      listen: listen,
    );
  }

  static ProductProvider deaf(context) {
    return of(context, listen: false);
  }

  static ChangeNotifierProvider<ProductProvider> getProvider(
    ProductsService service,
  ) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(
        service: service,
      ),
    );
  }
}
