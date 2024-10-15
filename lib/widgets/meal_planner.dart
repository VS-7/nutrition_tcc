import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/add_meal_screen.dart';
import '../providers/taco_meal_provider.dart';
import '../models/taco_meal.dart';

class MealPlanner extends StatelessWidget {
  final DateTime selectedDate;

  const MealPlanner({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Alimentação",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          MealItem(
            imagePath: 'assets/images/coffe.png',
            name: 'Café da manhã',
            mealType: 'Café da manhã',
            selectedDate: selectedDate,
          ),
          Divider(color: Colors.grey, height: 2),
          MealItem(
            imagePath: 'assets/images/lunch.png',
            name: 'Almoço',
            mealType: 'Almoço',
            selectedDate: selectedDate,
          ),
          Divider(color: Colors.grey, height: 2),
          MealItem(
            imagePath: 'assets/images/snack.png',
            name: 'Lanche',
            mealType: 'Lanche',
            selectedDate: selectedDate,
          ),
          Divider(color: Colors.grey, height: 2),
          MealItem(
            imagePath: 'assets/images/dinner.png',
            name: 'Jantar',
            mealType: 'Jantar',
            selectedDate: selectedDate,
          ),
        ],
      ),
    );
  }
}

class MealItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String mealType;
  final DateTime selectedDate;

  const MealItem({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.mealType,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TacoMealProvider>(
      builder: (context, mealProvider, child) {
        double consumedCalories = mealProvider.getTotalCaloriesByTypeAndDate(mealType, selectedDate);

        return GestureDetector(
          onTap: () => _navigateToAddMealScreen(context, mealType),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: consumedCalories / 1000, // Assuming a goal of 1000 calories per meal
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        strokeWidth: 4,
                      ),
                      ClipOval(
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${consumedCalories.toStringAsFixed(0)} / 1000 kcal', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  width: 30,
                  height: 30,
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
                    onPressed: () => _navigateToAddMealScreen(context, mealType),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToAddMealScreen(BuildContext context, String mealType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMealScreen(mealType: mealType, selectedDate: selectedDate),
      ),
    );
  }
}