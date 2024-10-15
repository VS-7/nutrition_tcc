import 'package:flutter/foundation.dart';
import '../models/taco_meal.dart';

class TacoMealProvider with ChangeNotifier {
  List<TacoMeal> _meals = [];

  List<TacoMeal> get meals => _meals;

  void addMeal(TacoMeal meal) {
    _meals.add(meal);
    notifyListeners();
  }

  void removeMeal(TacoMeal meal) {
    _meals.remove(meal);
    notifyListeners();
  }

  List<TacoMeal> getMealsByTypeAndDate(String mealType, DateTime date) {
    return _meals.where((meal) => 
      meal.mealType == mealType && 
      isSameDay(meal.date, date)
    ).toList();
  }

  double getTotalCaloriesByTypeAndDate(String mealType, DateTime date) {
    return getMealsByTypeAndDate(mealType, date).fold(
      0, (sum, meal) => sum + meal.food.energia * meal.quantity
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }
}