enum MealPlanType {
  breakfast,
  lunch,
  snack,
  dinner,
}

class MealPlan {
  final int? id;
  final DateTime dateTime;
  final MealPlanType type;
  final List<Map<String, dynamic>> foods; // Dados diretos da TACO
  final Map<String, double> foodQuantities; // Map de foodName para quantidade

  MealPlan({
    this.id,
    required this.dateTime,
    required this.type,
    required this.foods,
    required this.foodQuantities,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'type': type.index,
    };
  }

  factory MealPlan.fromMap(Map<String, dynamic> map, List<Map<String, dynamic>> foods, Map<String, double> foodQuantities) {
    return MealPlan(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      type: MealPlanType.values[map['type']],
      foods: foods,
      foodQuantities: foodQuantities,
    );
  }
}