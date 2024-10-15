import 'package:macro_counter/models/taco_food.dart';

class TacoMeal {
  final int id;
  final TacoFood food;
  final double quantity;
  final String mealType;
  final DateTime date;

  TacoMeal({
    required this.id,
    required this.food,
    required this.quantity,
    required this.mealType,
    required this.date,
  });
}