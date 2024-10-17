import 'package:flutter/material.dart';
import '../models/taco_food.dart';
import '../models/taco_meal.dart';

class AddFoodBottomSheet extends StatefulWidget {
  final TacoFood food;
  final Function(TacoMeal) onAdd;
  final String mealType;
  final DateTime selectedDate;

  const AddFoodBottomSheet({
    Key? key,
    required this.food,
    required this.onAdd,
    required this.mealType,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _AddFoodBottomSheetState createState() => _AddFoodBottomSheetState();
}

class _AddFoodBottomSheetState extends State<AddFoodBottomSheet> {
  double quantity = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adicionar ${widget.food.nome}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 20),
                    _buildNutritionInfo(),
                    SizedBox(height: 20),
                    Text('Quantidade (g):'),
                    Slider(
                        value: quantity,
                        min: 1,
                        max: 500,
                        divisions: 499,
                        activeColor: Colors.black,
                        inactiveColor: Colors.grey[300],
                        onChanged: (value) {
                        setState(() {
                            quantity = value;
                        });
                        },
                    ),
                    Text('${quantity.toStringAsFixed(0)}g'),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Adicionar'),
                    onPressed: _addFood,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: Size(350, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),

                      ),
                    ),
                  ),
                ],
              ),
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
      width: 60,
      height: 5,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }

  Widget _buildNutritionInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _nutritionRow('Calorias', widget.food.energia, 'kcal'),
        _nutritionRow('Proteínas', widget.food.proteina, 'g'),
        _nutritionRow('Carboidratos', widget.food.carboidrato, 'g'),
        _nutritionRow('Gorduras', widget.food.lipideos, 'g'),
      ],
    );
  }

  Widget _nutritionRow(String label, double value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${(value * quantity / 100).toStringAsFixed(1)} $unit', 
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _addFood() {
    final meal = TacoMeal(
      id: 0,
      food: widget.food,
      quantity: quantity / 100,
      mealType: widget.mealType,
      date: widget.selectedDate,
    );
    widget.onAdd(meal);
    Navigator.of(context).pop();
  }
}