
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kingslabs_mt/core/constants/api_endpoints.dart';
import 'package:kingslabs_mt/models/product_model.dart';

class ProductRepostiory {
  Future<ProductModel> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse(ApiEndpoints.productsUrl));

      if (response.statusCode == 200) {
    
        ProductModel fetchedProducts = productModelFromJson(response.body);

        return fetchedProducts;
      } else {
        throw Exception("Failed to fetch products");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }


Future<Product> fetchDetails(int id) async {
    try {
      final response = await http
          .get(Uri.parse("${ApiEndpoints.productsUrl}/$id"));

      if (response.statusCode == 200) {
        Product fetchDetails = Product.fromJson(jsonDecode(  response.body));

        return fetchDetails;
      } else {
        throw Exception("Failed to fetch products");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}