import 'package:flutter/material.dart';
import '../widgets/background_container.dart';
import '../data/optimization_dao.dart';
import '../providers/services/meal_optimization_service.dart';
import '../models/optimization_food.dart';
import '../providers/services/meal_type.dart';
import '../providers/user_settings_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/meals_recommendation_screen_widgets/meal_recomendation_item.dart';
import '../dialogs/meal_details_bottom_sheet.dart';

class MealRecommendationScreen extends StatefulWidget {
  const MealRecommendationScreen({Key? key}) : super(key: key);

  @override
  State<MealRecommendationScreen> createState() => _MealRecommendationScreenState();
}

class _MealRecommendationScreenState extends State<MealRecommendationScreen> {
  final OptimizationDao _optimizationDao = OptimizationDao();
  Map<MealType, Map<OptimizationFood, double>>? _recommendations;
  bool _isLoading = true;
  String? _errorMessage;
  bool _showFullMeal = false;
  MealType? _selectedMeal;

  @override
  void initState() {
    super.initState();
    // Removido o _loadRecommendation() automático
  }

  Future<void> _loadRecommendation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final foods = await _optimizationDao.getAllOptimizationFoods();
      final userSettings = await context.read<UserSettingsProvider>().object;
      
      if (userSettings == null) {
        setState(() {
          _errorMessage = 'Configurações do usuário não encontradas';
          _isLoading = false;
        });
        return;
      }

      final service = MealOptimizationService(
        foods: foods,
        userSettings: userSettings,
      );
      
      final recommendations = await service.optimizeAllMeals();
      
      setState(() {
        _recommendations = recommendations;
        _isLoading = false;
        if (recommendations.isEmpty) {
          _errorMessage = 'Não foi possível encontrar uma combinação válida de alimentos que atenda às restrições nutricionais.';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao gerar recomendações: $e';
        _isLoading = false;
      });
    }
  }

  void _showMealDetails(MealType mealType) {
    final recommendations = _recommendations?[mealType];
    if (recommendations == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: MealDetailsBottomSheet(
          mealTitle: _getMealTitle(mealType),
          mealRecommendations: recommendations,
        ),
      ),
    );
  }

  String _getMealTitle(MealType mealType) {
    switch (mealType) {
      case MealType.breakfast:
        return 'Café da Manhã';
      case MealType.lunch:
        return 'Almoço';
      case MealType.snack:
        return 'Lanche';
      case MealType.dinner:
        return 'Jantar';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            IconButton(
                              icon: const Text(
                                '⭐',
                                style: TextStyle(fontSize: 24),
                              ),
                              onPressed: () {
                                // Implementar favoritos
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Seus Favoritos',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            IconButton(
                              icon: const Text(
                                '💡',
                                style: TextStyle(fontSize: 24),
                              ),
                              onPressed: () {
                                // Implementar informações
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Informações',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            if (_recommendations != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sua Recomendação Alimentar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.star_border),
                          onPressed: () {
                            // Implementar favoritar
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    Text(
                      'Data: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    MealRecommendationItem(
                      title: 'Café Da Manhã',
                      imagePath: 'assets/images/coffe.png',
                      calories: _calculateMealCalories(MealType.breakfast),
                      carbs: _calculateMealNutrient(MealType.breakfast, 'carboidrato'),
                      protein: _calculateMealNutrient(MealType.breakfast, 'proteina'),
                      fat: _calculateMealNutrient(MealType.breakfast, 'lipideos'),
                      onTap: () => _showMealDetails(MealType.breakfast),
                    ),
                    const Divider(height: 1),
                    MealRecommendationItem(
                      title: 'Almoço',
                      imagePath: 'assets/images/lunch.png',
                      calories: _calculateMealCalories(MealType.lunch),
                      carbs: _calculateMealNutrient(MealType.lunch, 'carboidrato'),
                      protein: _calculateMealNutrient(MealType.lunch, 'proteina'),
                      fat: _calculateMealNutrient(MealType.lunch, 'lipideos'),
                      onTap: () => _showMealDetails(MealType.lunch),
                    ),
                    const Divider(height: 1),
                    MealRecommendationItem(
                      title: 'Lanche',
                      imagePath: 'assets/images/snack.png',
                      calories: _calculateMealCalories(MealType.snack),
                      carbs: _calculateMealNutrient(MealType.snack, 'carboidrato'),
                      protein: _calculateMealNutrient(MealType.snack, 'proteina'),
                      fat: _calculateMealNutrient(MealType.snack, 'lipideos'),
                      onTap: () => _showMealDetails(MealType.snack),
                    ),
                    const Divider(height: 1),
                    MealRecommendationItem(
                      title: 'Jantar',
                      imagePath: 'assets/images/dinner.png',
                      calories: _calculateMealCalories(MealType.dinner),
                      carbs: _calculateMealNutrient(MealType.dinner, 'carboidrato'),
                      protein: _calculateMealNutrient(MealType.dinner, 'proteina'),
                      fat: _calculateMealNutrient(MealType.dinner, 'lipideos'),
                      onTap: () => _showMealDetails(MealType.dinner),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Expanded(
                child: Center(
                  child: Text('Clique em Otimizar para gerar recomendações'),
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loadRecommendation,
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        label: const Text(
          'Otimize',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  double _calculateMealCalories(MealType mealType) {
    final meal = _recommendations?[mealType];
    if (meal == null) return 0;
    return _calculateNutritionTotals(meal)['energia'] ?? 0;
  }

  double _calculateMealNutrient(MealType mealType, String nutrient) {
    final meal = _recommendations?[mealType];
    if (meal == null) return 0;
    return _calculateNutritionTotals(meal)[nutrient] ?? 0;
  }


  Map<String, double> _calculateNutritionTotals(Map<OptimizationFood, double> recommendations) {
    final totals = {
      'energia': 0.0,
      'proteina': 0.0,
      'carboidrato': 0.0,
      'lipideos': 0.0,
      'fibra': 0.0,
      'zinco': 0.0,
      'ferro': 0.0,
      'manganes': 0.0,
      'calcio': 0.0,
      'fosforo': 0.0,
      'magnesio': 0.0,
    };

    for (var entry in recommendations.entries) {
      final food = entry.key;
      final quantity = entry.value;
      final factor = quantity / 100;

      totals['energia'] = (totals['energia']! + food.energia * factor);
      totals['proteina'] = (totals['proteina']! + food.proteina * factor);
      totals['carboidrato'] = (totals['carboidrato']! + food.carboidrato * factor);
      totals['lipideos'] = (totals['lipideos']! + food.lipideos * factor);
      totals['fibra'] = (totals['fibra']! + food.fibraAlimentar * factor);
      totals['zinco'] = (totals['zinco']! + food.zinco * factor);
      totals['ferro'] = (totals['ferro']! + food.ferro * factor);
      totals['manganes'] = (totals['manganes']! + food.manganes * factor);
      totals['calcio'] = (totals['calcio']! + food.calcio * factor);
      totals['fosforo'] = (totals['fosforo']! + food.fosforo * factor);
      totals['magnesio'] = (totals['magnesio']! + food.magnesio * factor);
    }

    return totals;
  }
}