import 'Ingredient.dart';

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

    return Product(
      name: json["product"]["product_name_en"],
      ingredients: Ingredient.parseIngredients(json["product"]["ingredients"])
    );
  }
}