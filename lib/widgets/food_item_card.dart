import 'package:flutter/material.dart';
import '../screens/food_details_screen.dart';
import '../models/taco_food.dart';

class FoodItemCard extends StatelessWidget {
  final TacoFood food;
  final Function(TacoFood) onAdd;

  const FoodItemCard({Key? key, required this.food, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailsScreen(food: food),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      food.nome,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    onPressed: () => onAdd(food),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('100g', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  Text('${food.energia.toStringAsFixed(1)} kcal', style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(height: 16),
              Divider(color: Colors.grey, height: 2),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNutrientInfo('Carboidratos', food.carboidrato),
                  _buildNutrientInfo('Proteínas', food.proteina),
                  _buildNutrientInfo('Lipídeos', food.lipideos),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(String label, double value) {
    return Column(
      children: [
        Text('${value.toStringAsFixed(1)}g', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}