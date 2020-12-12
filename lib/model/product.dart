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
      allergens.add(allergen.split(" en:")[1]);
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

  bool isVegan() {
    for (Ingredient ingredient in ingredients) {
      if (ingredient.isVegan == Status.NO) {
        return false;
      }
    }
    return true;
  }

  List<Ingredient> getNonVeganIngredients() {
    List<Ingredient> result = List();
    for (Ingredient ingredient in ingredients) {
      if (ingredient.isVegan == Status.NO || ingredient.isVegan == Status.MAYBE) {
        result.add(ingredient);
      }
    }
    return result;
  }

  bool isVegetarian() {
    for (Ingredient ingredient in ingredients) {
      if (ingredient.isVegetarian == Status.NO) {
        return false;
      }
    }
    return true;
  }

  List<Ingredient> getNonVegetarianIngredients() {
    List<Ingredient> result = List();
    for (Ingredient ingredient in ingredients) {
      if (ingredient.isVegetarian == Status.NO || ingredient.isVegetarian == Status.MAYBE) {
        result.add(ingredient);
      }
    }
    return result;
  }

  bool hasPalmOil() {
    for (Ingredient ingredient in ingredients) {
      if (ingredient.hasPalmOil == Status.NO) {
        return true;
      }
    }
    return false;
  }

  List<Ingredient> getPalmOilIngredients() {
    List<Ingredient> result = List();
    for (Ingredient ingredient in ingredients) {
      if (ingredient.hasPalmOil == Status.YES || ingredient.hasPalmOil == Status.MAYBE) {
        result.add(ingredient);
      }
    }
    return result;
  }

  bool hasAllergens() {
    return allergens.isNotEmpty;
  }
}