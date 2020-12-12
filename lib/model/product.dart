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
      return null;
    } else if (json["product"]["product_name"] == null) {
      return null;
    } else if (json["code"] == null) {
      return null;
    }

    List<dynamic> jsonIngredients = json["product"]["ingredients"];
    int ingredientsLength = json["product"]["ingredients"] == null ? 0 : jsonIngredients.length;
    List<Ingredient> ingredients = List();
    for (int i = 0; i < ingredientsLength; i++) {
      ingredients.add(Ingredient.fromJson(jsonIngredients[i]));
    }
    if (ingredients.isEmpty) {
      return null;
    }

    List<String> rawAllergens = json["product"]["allergens"].split(",");
    List<String> trimmedAllergens = List();
    if (rawAllergens.length != 0 && rawAllergens[0] != "") { // somehow can be empty string
      for (String allergen in rawAllergens) {
        trimmedAllergens.add(allergen.substring(3));
      }
    }
    if (trimmedAllergens.isEmpty) {
      trimmedAllergens.add("-");
    }

    return Product(
      name: json["product"]["product_name"],
      barcode: json["code"],
      ingredients: ingredients,
      allergens: trimmedAllergens,
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