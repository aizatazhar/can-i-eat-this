import 'ingredient.dart';

class Product {
  final String name;
  final List<Ingredient> ingredients;

  Product({
    this.name,
    this.ingredients
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    if (json["status"] == 0) {
      return Product(
        name: "No such product",
        ingredients: null,
      );
    }

    List<dynamic> jsonIngredients = json["product"]["ingredients"];
    int ingredientsLength = json["product"]["ingredients"] == null ? 0 : jsonIngredients.length;
    List<Ingredient> ingredients = List();
    for (int i = 0; i < ingredientsLength; i++) {
      ingredients.add(Ingredient.fromJson(jsonIngredients[i]));
    }

    return Product(
        name: json["product"]["product_name"],
        ingredients: ingredients,
    );
  }
}