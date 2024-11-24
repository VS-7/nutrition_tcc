import 'package:flutter/material.dart';

class MealRecommendationItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final double calories;
  final double carbs;
  final double protein;
  final double fat;
  final VoidCallback? onTap;

  const MealRecommendationItem({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.onTap,
  }) : super(key: key);

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            // Imagem com mesmo tamanho do MealPlanner
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset(
                    imagePath,
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Conteúdo expandido com informações nutricionais
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNutrientInfo(_formatNumber(calories), 'Calorias'),
                      ),
                      Expanded(
                        child: _buildNutrientInfo('${_formatNumber(carbs)} g', 'Carb'),
                      ),
                      Expanded(
                        child: _buildNutrientInfo('${_formatNumber(protein)} g', 'Proteína'),
                      ),
                      Expanded(
                        child: _buildNutrientInfo('${_formatNumber(fat)} g', 'Gordura'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}