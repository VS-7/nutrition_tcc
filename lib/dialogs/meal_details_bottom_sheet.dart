import 'package:flutter/material.dart';
import '../models/optimization_food.dart';

class MealDetailsBottomSheet extends StatelessWidget {
  final String mealTitle;
  final Map<OptimizationFood, double> mealRecommendations;

  const MealDetailsBottomSheet({
    Key? key,
    required this.mealTitle,
    required this.mealRecommendations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(80)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        mealTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildFoodList(),
                    const SizedBox(height: 24),
                    _buildMacronutrients(),
                    const SizedBox(height: 24),
                    _buildMicronutrients(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 5,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }

  Widget _buildMacronutrients() {
    final totals = _calculateNutritionTotals();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Macronutrientes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _nutritionItem('Calorias', totals['energia']!, 'kcal'),
              _nutritionItem('Proteínas', totals['proteina']!, 'g'),
              _nutritionItem('Carboidratos', totals['carboidrato']!, 'g'),
              _nutritionItem('Gorduras', totals['lipideos']!, 'g'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMicronutrients() {
    final totals = _calculateNutritionTotals();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micronutrientes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildMicronutrientRow('Fibras', totals['fibra']!),
          _buildMicronutrientRow('Zinco', totals['zinco']!),
          _buildMicronutrientRow('Ferro', totals['ferro']!),
          _buildMicronutrientRow('Manganês', totals['manganes']!),
          _buildMicronutrientRow('Cálcio', totals['calcio']!),
          _buildMicronutrientRow('Fósforo', totals['fosforo']!),
          _buildMicronutrientRow('Magnésio', totals['magnesio']!),
        ],
      ),
    );
  }

  Widget _buildMicronutrientRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            '${value.toStringAsFixed(1)}g',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _nutritionItem(String label, double value, String unit) {
    return Column(
      children: [
        Text(
          '${value.toStringAsFixed(1)} $unit',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alimentos Recomendados',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...mealRecommendations.entries.map((entry) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        entry.key.nome,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${entry.value.toStringAsFixed(1)} g',
                      style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          '${(entry.key.energia * entry.value / 100).toStringAsFixed(1)} kcal',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
                if (entry != mealRecommendations.entries.last)
                  const Divider(color: Colors.grey),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Map<String, double> _calculateNutritionTotals() {
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

    for (var entry in mealRecommendations.entries) {
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