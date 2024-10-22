import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/add_meal_screen.dart';
import '../../screens/meal_details_screen.dart';
import '../../providers/taco_meal_provider.dart';
import '../../providers/user_settings_provider.dart';
import '../../models/taco_meal.dart';
import '../../models/user_settings.dart';

class MealPlanner extends StatelessWidget {
  final DateTime selectedDate;

  const MealPlanner({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSettingsProvider>(
      builder: (context, userSettingsProvider, child) {
        return FutureBuilder<UserSettings?>(
          future: userSettingsProvider.object,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Text('Erro ao carregar as configurações do usuário');
            }
            UserSettings userSettings = snapshot.data!;
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
                    calorieGoal: userSettings.breakfastCalorieGoal,
                  ),
                  Divider(color: Colors.grey, height: 2),
                  MealItem(
                    imagePath: 'assets/images/lunch.png',
                    name: 'Almoço',
                    mealType: 'Almoço',
                    selectedDate: selectedDate,
                    calorieGoal: userSettings.lunchCalorieGoal,
                  ),
                  Divider(color: Colors.grey, height: 2),
                  MealItem(
                    imagePath: 'assets/images/snack.png',
                    name: 'Lanche',
                    mealType: 'Lanche',
                    selectedDate: selectedDate,
                    calorieGoal: userSettings.snackCalorieGoal,
                  ),
                  Divider(color: Colors.grey, height: 2),
                  MealItem(
                    imagePath: 'assets/images/dinner.png',
                    name: 'Jantar',
                    mealType: 'Jantar',
                    selectedDate: selectedDate,
                    calorieGoal: userSettings.dinnerCalorieGoal,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class MealItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String mealType;
  final DateTime selectedDate;
  final double calorieGoal;

  const MealItem({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.mealType,
    required this.selectedDate,
    required this.calorieGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TacoMealProvider>(
      builder: (context, mealProvider, child) {
        double consumedCalories = mealProvider.getTotalCaloriesByTypeAndDate(mealType, selectedDate);

        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _navigateToMealDetailsScreen(context, mealType),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              value: consumedCalories / calorieGoal,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA7E100)),
                              strokeWidth: 4,
                            ),
                          ),
                          Image.asset(
                            imagePath,
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${consumedCalories.toStringAsFixed(0)} / ${calorieGoal.toStringAsFixed(0)} kcal', style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
        );
      },
    );
  }

  void _navigateToMealDetailsScreen(BuildContext context, String mealType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailsScreen(mealType: mealType, selectedDate: selectedDate),
      ),
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