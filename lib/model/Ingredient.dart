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

  // Takes in a list of ingredients in json format and returns a list of
  // Ingredient objects
  static List<Ingredient> parseIngredients(List<dynamic> json) {
    List<Ingredient> result = List();

    for (int i = 0; i < json.length; i++) {
      Status isVegan;
      if (json[i]["vegan"] == "yes") {
        isVegan = Status.YES;
      } else if (json[i]["vegan"] == "no") {
        isVegan = Status.NO;
      } else {
        isVegan = null;
      }

      Status isVegetarian;
      if (json[i]["vegan"] == "yes") {
        isVegetarian = Status.YES;
      } else if (json[i]["vegan"] == "no") {
        isVegetarian = Status.NO;
      } else {
        isVegetarian = null;
      }

      Status hasPalmOil;
      if (json[i]["from_palm_oil"] == "yes") {
        hasPalmOil = Status.YES;
      } else if (json[i]["from_palm_oil"] == "no") {
        hasPalmOil = Status.NO;
      } else if (json[i]["from_palm_oil"] == "maybe") {
        hasPalmOil = Status.MAYBE;
      } else {
        hasPalmOil = null;
      }

      result.add(Ingredient(
        name: json[i]["text"].toString(),
        isVegan: isVegan,
        isVegetarian: isVegetarian,
        hasPalmOil: hasPalmOil,
      ));
    }

    return result;
  }

  @override
  String toString() {
    return this.name + " " + this.hasPalmOil.toString() + " " + this.isVegetarian.toString() + " " + this.isVegetarian.toString();
  }
}