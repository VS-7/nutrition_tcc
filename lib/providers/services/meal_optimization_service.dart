import 'dart:math' show max;
import '../../models/optimization_food.dart';
import '../../models/user_settings.dart';
import 'meal_type.dart';
import 'genetic_meal_optimizer.dart';

class MealOptimizationService {
  final List<OptimizationFood> foods;
  final UserSettings userSettings;

  MealOptimizationService({
    required this.foods,
    required this.userSettings,
  });

  Future<Map<MealType, Map<OptimizationFood, double>>> optimizeAllMeals() async {
    if (foods.isEmpty) return {};

    try {
      // Distribuir calorias entre as refeições
      final mealCalories = _distributeMealCalories(userSettings.calorieGoal);
      
      // Otimizar cada refeição separadamente
      final breakfastFoods = _filterFoodsByCategories(foods, ['B', 'F', 'C1']);
      final lunchFoods = _filterFoodsByCategories(foods, ['C2', 'G', 'V', 'P', 'S']);
      final snackFoods = _filterFoodsByCategories(foods, ['F', 'L', 'B', 'C1']);
      final dinnerFoods = _filterFoodsByCategories(foods, ['C2', 'G', 'V', 'P']);

      final result = {
        MealType.breakfast: await _optimizeMeal(
          breakfastFoods, 
          mealCalories[MealType.breakfast]!,
          0.25, // 25% dos nutrientes diários
        ),
        MealType.lunch: await _optimizeMeal(
          lunchFoods, 
          mealCalories[MealType.lunch]!,
          0.35, // 35% dos nutrientes diários
        ),
        MealType.snack: await _optimizeMeal(
          snackFoods, 
          mealCalories[MealType.snack]!,
          0.15, // 15% dos nutrientes diários
        ),
        MealType.dinner: await _optimizeMeal(
          dinnerFoods, 
          mealCalories[MealType.dinner]!,
          0.25, // 25% dos nutrientes diários
        ),
      };

      // Verificar se todas as refeições foram otimizadas com sucesso
      if (result.values.every((meal) => meal.isNotEmpty)) {
        return result;
      }

      return {};
    } catch (e) {
      print('Erro na otimização das refeições: $e');
      return {};
    }
  }

  Map<MealType, double> _distributeMealCalories(double totalCalories) {
    return {
      MealType.breakfast: totalCalories * 0.25, // 25% das calorias
      MealType.lunch: totalCalories * 0.35,     // 35% das calorias
      MealType.snack: totalCalories * 0.15,     // 15% das calorias
      MealType.dinner: totalCalories * 0.25,    // 25% das calorias
    };
  }

  List<OptimizationFood> _filterFoodsByCategories(
    List<OptimizationFood> foods, 
    List<String> categories
  ) {
    return foods.where((food) => categories.contains(food.categoria)).toList();
  }

  Future<Map<OptimizationFood, double>> _optimizeMeal(
    List<OptimizationFood> mealFoods,
    double targetCalories,
    double nutrientFactor,
  ) async {
    if (mealFoods.isEmpty) return {};

    try {
      // Ajustando para os valores corretos da tabela
      final nutritionalTargets = {
        'fibra': 25.0 * nutrientFactor,      // ≥ 25g
        'carboidrato': 300.0 * nutrientFactor, // ≥ 300g
        'proteina': 75.0 * nutrientFactor,    // ≥ 75g
        'calcio': 1000.0 * nutrientFactor,    // ≥ 1000mg
        'manganes': 2.3 * nutrientFactor,     // ≥ 2.3mg
        'ferro': 14.0 * nutrientFactor,       // ≥ 14mg
        'magnesio': 260.0 * nutrientFactor,   // ≥ 260mg
        'fosforo': 700.0 * nutrientFactor,    // ≥ 700mg
        'zinco': 7.0 * nutrientFactor,        // ≥ 7mg
      };

      final optimizer = GeneticMealOptimizer(
        foods: mealFoods,
        targetCalories: targetCalories,
        nutritionalTargets: nutritionalTargets,
      );

      var result = optimizer.optimize();
      
      // Validar se a solução atende aos requisitos mínimos
      if (result.isNotEmpty) {
        Map<String, double> totalNutrients = {
          'fibra': 0,
          'carboidrato': 0,
          'proteina': 0,
          'calcio': 0,
          'manganes': 0,
          'ferro': 0,
          'magnesio': 0,
          'fosforo': 0,
          'zinco': 0,
        };

        // Calcular totais
        for (var entry in result.entries) {
          _updateNutrients(totalNutrients, entry.key, entry.value);
        }

        // Log dos nutrientes obtidos
        print('\nNutrientes obtidos na refeição:');
        totalNutrients.forEach((nutrient, value) {
          print('$nutrient: $value (alvo: ${nutritionalTargets[nutrient]})');
        });
      }

      return result;
    } catch (e) {
      print('Erro na otimização da refeição: $e');
      return {};
    }
  }

  void _updateNutrients(Map<String, double> currentNutrients, OptimizationFood food, double quantity) {
    final factor = quantity / 100;
    currentNutrients['fibra'] = (currentNutrients['fibra']! + food.fibraAlimentar * factor);
    currentNutrients['carboidrato'] = (currentNutrients['carboidrato']! + food.carboidrato * factor);
    currentNutrients['proteina'] = (currentNutrients['proteina']! + food.proteina * factor);
    currentNutrients['calcio'] = (currentNutrients['calcio']! + food.calcio * factor);
    currentNutrients['manganes'] = (currentNutrients['manganes']! + food.manganes * factor);
    currentNutrients['ferro'] = (currentNutrients['ferro']! + food.ferro * factor);
    currentNutrients['magnesio'] = (currentNutrients['magnesio']! + food.magnesio * factor);
    currentNutrients['fosforo'] = (currentNutrients['fosforo']! + food.fosforo * factor);
    currentNutrients['zinco'] = (currentNutrients['zinco']! + food.zinco * factor);
  }

  bool _isSolutionViable(
    Map<String, double> current,
    Map<String, double> targets,
    double currentCalories,
    double targetCalories,
    double tolerance,
  ) {
    if (currentCalories < targetCalories * 0.8 || 
        currentCalories > targetCalories * 1.2) {
      print('Calorias fora do intervalo: $currentCalories (alvo: $targetCalories)');
      return false;
    }

    for (var nutrient in targets.keys) {
      if (current[nutrient]! < targets[nutrient]! * tolerance) {
        print('$nutrient insuficiente: ${current[nutrient]} (mínimo: ${targets[nutrient]! * tolerance})');
        return false;
      }
    }

    return true;
  }

  double _calculateNutritionalScore(OptimizationFood food, Map<String, double> targets) {
    double score = 0;
    score += (food.fibraAlimentar / targets['fibra']!) * 100;
    score += (food.carboidrato / targets['carboidrato']!) * 100;
    score += (food.proteina / targets['proteina']!) * 100;
    score += (food.calcio / targets['calcio']!) * 100;
    score += (food.manganes / targets['manganes']!) * 100;
    score += (food.ferro / targets['ferro']!) * 100;
    score += (food.magnesio / targets['magnesio']!) * 100;
    score += (food.fosforo / targets['fosforo']!) * 100;
    score += (food.zinco / targets['zinco']!) * 100;
    return score / food.energia; // Densidade nutricional por caloria
  }

  double _calculateMaxQuantity(
    OptimizationFood food,
    double targetCalories,
    double currentCalories,
    Map<String, double> targets,
    Map<String, double> current,
  ) {
    double remainingCalories = targetCalories - currentCalories;
    double quantity = (remainingCalories / food.energia) * 100;
    
    // Limitar a quantidade máxima a 300g por alimento
    quantity = quantity.clamp(0, 300);
    
    return quantity;
  }
}
