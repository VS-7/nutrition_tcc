import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/taco_meal_provider.dart';
import '../models/taco_meal.dart';
import '../widgets/background_container.dart';
import 'add_meal_screen.dart';

class MealDetailsScreen extends StatelessWidget {
  final String mealType;
  final DateTime selectedDate;

  const MealDetailsScreen({Key? key, required this.mealType, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            mealType,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Consumer<TacoMealProvider>(
          builder: (context, mealProvider, child) {
            List<TacoMeal> meals = mealProvider.getMealsByTypeAndDate(mealType, selectedDate);
            double totalCalories = meals.fold(0, (sum, meal) => sum + meal.food.energia * meal.quantity);
            double totalProtein = meals.fold(0, (sum, meal) => sum + meal.food.proteina * meal.quantity);
            double totalCarbs = meals.fold(0, (sum, meal) => sum + meal.food.carboidrato * meal.quantity);
            double totalFat = meals.fold(0, (sum, meal) => sum + meal.food.lipideos * meal.quantity);
            
            return PageView(
              children: [
                // First page: Statistics
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatisticCard(
                        title: 'Calorias',
                        value: totalCalories.toStringAsFixed(0),
                        unit: 'kcal',
                        goal: '500', // Replace with actual goal
                      ),
                      SizedBox(height: 16),
                      StatisticCard(
                        title: 'Proteínas',
                        value: totalProtein.toStringAsFixed(1),
                        unit: 'g',
                      ),
                      SizedBox(height: 16),
                      StatisticCard(
                        title: 'Carboidratos',
                        value: totalCarbs.toStringAsFixed(1),
                        unit: 'g',
                      ),
                      SizedBox(height: 16),
                      StatisticCard(
                        title: 'Gorduras',
                        value: totalFat.toStringAsFixed(1),
                        unit: 'g',
                      ),
                    ],
                  ),
                ),
                // Second page: Food list
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: meals.length,
                        itemBuilder: (context, index) {
                          TacoMeal meal = meals[index];
                          return ListTile(
                            title: Text(meal.food.nome ?? 'Alimento sem nome'),
                            subtitle: Text('${meal.quantity} g'),
                            trailing: IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () async {
                                await mealProvider.deleteMeal(meal.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Alimento removido')),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        child: Text('Adicionar Alimento'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMealScreen(mealType: mealType, selectedDate: selectedDate),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String? goal;

  const StatisticCard({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    this.goal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$value $unit', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                if (goal != null) Text('Meta: $goal $unit', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}