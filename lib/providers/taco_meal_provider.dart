import 'package:flutter/foundation.dart';
import 'package:macro_counter/data/taco_meal_dao.dart';
import 'package:macro_counter/models/taco_meal.dart';

class TacoMealProvider with ChangeNotifier {
  final TacoMealDao _tacoMealDao;
  List<TacoMeal> _meals = [];

  TacoMealProvider(this._tacoMealDao);

  List<TacoMeal> get meals => _meals;

  Future<void> loadMeals(DateTime date) async {
    _meals = await _tacoMealDao.getMealsByDate(date);
    notifyListeners();
  }

  Future<void> addMeal(TacoMeal meal) async {
    final id = await _tacoMealDao.insert(meal);
    final newMeal = TacoMeal(
      id: id,
      food: meal.food,
      quantity: meal.quantity,
      mealType: meal.mealType,
      date: meal.date,
    );
    _meals.add(newMeal);
    notifyListeners();
  }

  Future<void> updateMeal(TacoMeal meal) async {
    await _tacoMealDao.update(meal);
    final index = _meals.indexWhere((m) => m.id == meal.id);
    if (index != -1) {
      _meals[index] = meal;
      notifyListeners();
    }
  }

  Future<void> deleteMeal(int id) async {
    await _tacoMealDao.delete(id);
    _meals.removeWhere((meal) => meal.id == id);
    notifyListeners();
  }

  List<TacoMeal> getMealsByTypeAndDate(String mealType, DateTime date) {
    return _meals.where((meal) =>
      meal.mealType == mealType &&
      meal.date.year == date.year &&
      meal.date.month == date.month &&
      meal.date.day == date.day
    ).toList();
  }

  double getTotalCaloriesByTypeAndDate(String mealType, DateTime date) {
    return getMealsByTypeAndDate(mealType, date).fold(
      0, (sum, meal) => sum + meal.food.energia * meal.quantity
    );
  }

  // Novo método para buscar refeições semanais
  Future<List<TacoMeal>> getWeeklyMeals(DateTime endDate) async {
    DateTime startDate = endDate.subtract(Duration(days: 6));
    List<TacoMeal> weeklyMeals = [];
    for (int i = 0; i <= 6; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      List<TacoMeal> dailyMeals = await _tacoMealDao.getMealsByDate(currentDate);
      weeklyMeals.addAll(dailyMeals);
    }
    return weeklyMeals;
  }

  Future<List<TacoMeal>> getMealsByDate(DateTime date) async {
    return await _tacoMealDao.getMealsByDate(date);
  }
}
