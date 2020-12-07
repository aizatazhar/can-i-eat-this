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
      return parseJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load product. Servers may be down.');
    }
  }

  Product parseJson(Map<String, dynamic> json) {
    if (json["status"] == 0 || json["product"]["product_name"] == null) {
      return Product(
        name: "No such product in database",
        ingredients: null,
      );
    }

    String productName = json["product"]["product_name"];

    List<Ingredient> productIngredients = List();
    int ingredientsLength;
    if (json["product"]["ingredients"] == null) {
      ingredientsLength = 0;
    } else {
      ingredientsLength = json["product"]["ingredients"].length;
    }
    for (int i = 0; i < ingredientsLength; i++) {
      Status isVegan;
      if (json["product"]["ingredients"][i]["vegan"] == "yes") {
        isVegan = Status.YES;
      } else if (json["product"]["ingredients"][i]["vegan"] == "no") {
        isVegan = Status.NO;
      } else {
        isVegan = null;
      }

      Status isVegetarian;
      if (json["product"]["ingredients"][i]["vegan"] == "yes") {
        isVegetarian = Status.YES;
      } else if (json["product"]["ingredients"][i]["vegan"] == "no") {
        isVegetarian = Status.NO;
      } else {
        isVegetarian = null;
      }

      Status hasPalmOil;
      if (json["product"]["ingredients"][i]["from_palm_oil"] == "yes") {
        hasPalmOil = Status.YES;
      } else if (json["product"]["ingredients"][i]["from_palm_oil"] == "no") {
        hasPalmOil = Status.NO;
      } else if (json["product"]["ingredients"][i]["from_palm_oil"] == "maybe") {
        hasPalmOil = Status.MAYBE;
      } else {
        hasPalmOil = null;
      }

      productIngredients.add(Ingredient(
        name: json["product"]["ingredients"][i]["text"].toString(),
        isVegan: isVegan,
        isVegetarian: isVegetarian,
        hasPalmOil: hasPalmOil,
      ));
    }

    return Product(
      name: productName,
      ingredients: productIngredients,
    );
  }
}