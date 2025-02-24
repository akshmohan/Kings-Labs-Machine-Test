import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingslabs_mt/models/product_model.dart';
import 'package:kingslabs_mt/repositories/product_repository.dart';


class DetailsViewModel extends ChangeNotifier {
  Product? product;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getDetails(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
  
      product = await ProductRepostiory().fetchDetails( id);
      log(product.toString(), name:"jug");
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}


final detailsProvider = ChangeNotifierProvider((ref) => DetailsViewModel());