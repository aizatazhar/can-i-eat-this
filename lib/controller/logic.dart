import 'package:can_i_eat_this/model/ingredient.dart';
import 'package:can_i_eat_this/model/product.dart';
import 'package:can_i_eat_this/model/status.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Logic {
  static final String jsonFormat = ".json";
  static final String productDomain = "https://world.openfoodfacts.org/api/v0/product/";
  static final String productFields = "&fields=";
  static final String ingredientParameter = "%2Cingredients";
  static final String nameParameter = "%2Cproduct_name";

  Future<Product> fetchProduct(String barcode) async {
    final String productUrl = productDomain + barcode + jsonFormat
        + productFields + ingredientParameter + nameParameter;
    final response = await http.get(productUrl);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Product.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load product. Servers may be down.');
    }
  }
}