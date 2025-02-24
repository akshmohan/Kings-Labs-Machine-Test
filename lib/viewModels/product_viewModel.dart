// ignore_for_file: prefer_final_fields


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingslabs_mt/models/product_model.dart';
import 'package:kingslabs_mt/repositories/product_repository.dart';


class ProductViewmodel with ChangeNotifier {
  final ProductRepostiory _productRepostiory;

  ProductViewmodel(this._productRepostiory);

  List<Product>_products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> getAllProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
   ProductModel data  = await _productRepostiory.fetchProducts();
   _products = data.products;
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}




final productProvider = ChangeNotifierProvider<ProductViewmodel>((ref) {
  final productRepostiory = ProductRepostiory();
  return ProductViewmodel(productRepostiory);
});