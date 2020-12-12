import 'ingredient.dart';

class Product {
  final String name;
  final String barcode;
  final List<Ingredient> ingredients;
  final List<String> allergens;

  Product({
    this.name,
    this.barcode,
    this.ingredients,
    this.allergens,
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

    List<String> allergens = List();
    for (String allergen in json["product"]["allergens"].split(",")) {
      allergens.add(allergen.split("en:")[1]);
    }

    return Product(
      name: json["product"]["product_name"],
      barcode: json["code"],
      ingredients: ingredients,
      allergens: allergens,
    );
  }

  @override
  String toString() {
    return name;
  }

  String ingredientsToString() {
    return ingredients.toString()
        .substring(1, ingredients.toString().length - 1);
  }

  bool isVegan() {
    for (Ingredient ingredient in ingredients) {
      if (ingredient.isVegan == Status.NO) {
        return false;
      }
    }

    return true;
  }

  bool isVegetarian() {
    for (Ingredient ingredient in ingredients) {
      if (ingredient.isVegetarian == Status.NO) {
        return false;
      }
    }

    return true;
  }

  bool hasPalmOil() {
    for (Ingredient ingredient in ingredients) {
      if (ingredient.hasPalmOil == Status.NO) {
        return true;
      }
    }

    return false;
  }

  bool hasAllergens() {
    return allergens.isNotEmpty;
  }

  String allergensToString() {
    return allergens.toString()
        .substring(1, allergens.toString().length - 1);
  }
}