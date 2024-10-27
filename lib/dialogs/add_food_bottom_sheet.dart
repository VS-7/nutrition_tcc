import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController _quantityController = TextEditingController();
  FocusNode _quantityFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _quantityController.text = quantity.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(80)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.food.nome}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: Colors.white),
                    ),
                    SizedBox(height: 24),
                    _buildNutritionInfo(),
                    SizedBox(height: 24),
                    _buildQuantitySelector(),
                    SizedBox(height: 24),
                    ElevatedButton(
                      child: Text('Adicionar'),
                      onPressed: _addFood,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
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
      width: 40,
      height: 5,
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }

  Widget _buildNutritionInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _nutritionRow('Calorias', widget.food.energia, 'kcal'),
          _nutritionRow('Proteínas', widget.food.proteina, 'g'),
          _nutritionRow('Carboidratos', widget.food.carboidrato, 'g'),
          _nutritionRow('Gorduras', widget.food.lipideos, 'g'),
        ],
      ),
    );
  }

  Widget _nutritionRow(String label, double value, String unit) {
    return Column(
      children: [
        Text(
          '${(value * quantity / 100).toStringAsFixed(1)} $unit',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline, color: Colors.white, size: 22),
          onPressed: () {
            _updateQuantity((quantity - 1).clamp(1, 500));
          },
        ),
        Container(
          width: 80,
          child: TextField(
            controller: _quantityController,
            focusNode: _quantityFocusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              suffixText: 'g',
              suffixStyle: TextStyle(color: Colors.white70),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              if (value.isNotEmpty) {
                _updateQuantity(double.parse(value).clamp(1, 500));
              }
            },
            onSubmitted: (value) {
              if (value.isEmpty) {
                _updateQuantity(1);
              }
              _quantityFocusNode.unfocus();
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 22),
          onPressed: () {
            _updateQuantity((quantity + 1).clamp(1, 500));
          },
        ),
      ],
    );
  }

  void _updateQuantity(double newQuantity) {
    setState(() {
      quantity = newQuantity;
      _quantityController.text = quantity.toStringAsFixed(0);
    });
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
