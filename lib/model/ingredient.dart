enum Status {YES, NO, MAYBE}

class Ingredient {
  final String name;
  final Status isVegan;
  final Status isVegetarian;
  final Status hasPalmOil;

  Ingredient({
    this.name,
    this.isVegan,
    this.isVegetarian,
    this.hasPalmOil,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    Status isVegan;
    if (json["vegan"] == "yes") {
      isVegan = Status.YES;
    } else if (json["vegan"] == "no") {
      isVegan = Status.NO;
    } else {
      isVegan = null;
    }

    Status isVegetarian;
    if (json["vegan"] == "yes") {
      isVegetarian = Status.YES;
    } else if (json["vegan"] == "no") {
      isVegetarian = Status.NO;
    } else {
      isVegetarian = null;
    }

    Status hasPalmOil;
    if (json["from_palm_oil"] == "yes") {
      hasPalmOil = Status.YES;
    } else if (json["from_palm_oil"] == "no") {
      hasPalmOil = Status.NO;
    } else if (json["from_palm_oil"] == "maybe") {
      hasPalmOil = Status.MAYBE;
    } else {
      hasPalmOil = null;
    }

    return Ingredient(
      name: json["text"].toString(),
      isVegan: isVegan,
      isVegetarian: isVegetarian,
      hasPalmOil: hasPalmOil,
    );
  }

  @override
  String toString() {
    return this.name;
  }
}