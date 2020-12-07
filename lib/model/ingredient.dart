import 'package:can_i_eat_this/model/status.dart';

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

  @override
  String toString() {
    return this.name;
  }
}