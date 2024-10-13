import 'package:flutter/foundation.dart';
import 'package:macro_counter/data/meal_plan_dao.dart';
import 'package:macro_counter/models/meal_plan.dart';
import 'package:macro_counter/data/taco_dao.dart';

class MealPlanProvider with ChangeNotifier {
  final MealPlanDao _mealPlanDao = MealPlanDao();
  final TacoDao _tacoDao = TacoDao();
  List<MealPlan> _mealPlans = [];

  List<MealPlan> get mealPlans => _mealPlans;

  Future<void> loadMealPlans() async {
    _mealPlans = await _mealPlanDao.readAll();
    notifyListeners();
  }

  Future<void> addMealPlan(MealPlan mealPlan) async {
    final id = await _mealPlanDao.insert(mealPlan);
    final newMealPlan = MealPlan(
      id: id,
      dateTime: mealPlan.dateTime,
      type: mealPlan.type,
      foods: mealPlan.foods,
      foodQuantities: mealPlan.foodQuantities,
    );
    _mealPlans.add(newMealPlan);
    notifyListeners();
  }

  Future<void> updateMealPlan(MealPlan mealPlan) async {
    await _mealPlanDao.update(mealPlan);
    final index = _mealPlans.indexWhere((m) => m.id == mealPlan.id);
    if (index != -1) {
      _mealPlans[index] = mealPlan;
      notifyListeners();
    }
  }

  Future<void> deleteMealPlan(int id) async {
    await _mealPlanDao.delete(id);
    _mealPlans.removeWhere((mealPlan) => mealPlan.id == id);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> searchFood(String query) async {
    return await _tacoDao.searchFoodByName(query);
  }

  Future<void> addFoodToMealPlan(MealPlan mealPlan, Map<String, dynamic> food, double quantity) async {
    if (!mealPlan.foods.contains(food)) {
      mealPlan.foods.add(food);
    }
    mealPlan.foodQuantities[food['Nome']] = quantity;
    await updateMealPlan(mealPlan);
  }

  Future<void> removeFoodFromMealPlan(MealPlan mealPlan, Map<String, dynamic> food) async {
    mealPlan.foods.removeWhere((f) => f['Nome'] == food['Nome']);
    mealPlan.foodQuantities.remove(food['Nome']);
    await updateMealPlan(mealPlan);
  }

  Future<List<String>> getCategories() async {
    return await _tacoDao.getCategories();
  }

  Future<List<Map<String, dynamic>>> getFoodsByCategory(String category) async {
    return await _tacoDao.getFoodsByCategory(category);
  }

  double calculateTotalCalories(MealPlan mealPlan) {
    return mealPlan.foods.fold(0, (total, food) {
      double quantity = mealPlan.foodQuantities[food['Nome']] ?? 1.0;
      return total + (food['Energia (kcal)'] as double) * quantity;
    });
  }

  Map<String, double> calculateTotalNutrients(MealPlan mealPlan) {
    Map<String, double> totalNutrients = {
      'Proteínas': 0,
      'Lipídeos': 0,
      'Carboidratos': 0,
    };

    for (var food in mealPlan.foods) {
      double quantity = mealPlan.foodQuantities[food['Nome']] ?? 1.0;
      totalNutrients['Proteínas'] = (totalNutrients['Proteínas'] ?? 0) + (food['Proteínas'] as double) * quantity;
      totalNutrients['Lipídeos'] = (totalNutrients['Lipídeos'] ?? 0) + (food['Lipídeos'] as double) * quantity;
      totalNutrients['Carboidratos'] = (totalNutrients['Carboidratos'] ?? 0) + (food['Carboidratos'] as double) * quantity;
    }

    return totalNutrients;
  }
}