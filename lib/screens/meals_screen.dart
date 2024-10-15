import 'package:flutter/material.dart';
import 'package:macro_counter/models/taco_meal.dart';
import 'package:macro_counter/providers/user_settings_provider.dart';
import 'package:macro_counter/providers/taco_meal_provider.dart';
import 'package:macro_counter/utils/date_formatter.dart';
import 'package:macro_counter/widgets/circular_progress_indicator.dart';
import 'package:macro_counter/widgets/meal_planner.dart';
import 'package:provider/provider.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TacoMealProvider>(context, listen: false).loadMeals(selectedDate);
    });
  }

  Map<String, double> getDailyTotal(List<TacoMeal> mealList) {
    double calorie = 0;
    double carb = 0;
    double protein = 0;
    double fat = 0;
    for (var meal in mealList) {
      calorie += meal.food.energia * meal.quantity;
      carb += meal.food.carboidrato * meal.quantity;
      protein += meal.food.proteina * meal.quantity;
      fat += meal.food.lipideos * meal.quantity;
    }
    return {
      "calorie": calorie,
      "carb": carb,
      "protein": protein,
      "fat": fat,
    };
  }

  @override
  Widget build(BuildContext context) {
    DateFormatter formatter = DateFormatter();

    final settingsProvider = Provider.of<UserSettingsProvider>(context);
    final mealProvider = Provider.of<TacoMealProvider>(context);

    List<TacoMeal> mealList = mealProvider.meals.where((meal) =>
      meal.date.year == selectedDate.year &&
      meal.date.month == selectedDate.month &&
      meal.date.day == selectedDate.day
    ).toList();

    Map<String, double> consumedMacros = getDailyTotal(mealList);
    double consumedCalories = consumedMacros['calorie']!;
    double consumedCarbs = consumedMacros['carb']!;
    double consumedProteins = consumedMacros['protein']!;
    double consumedFats = consumedMacros['fat']!;

  void _showDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDate: selectedDate
    ).then(
      (value) {
        if (value != null) {
          setState(() {
            selectedDate = value;
          });
          Provider.of<TacoMealProvider>(context, listen: false).loadMeals(selectedDate);
        }
      },
    );
  }

    return FutureBuilder(
      future: settingsProvider.object,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final data = snapshot.data;
          double calorieGoal = data!.calorieGoal;
          double carbGoal = data.carbGoal;
          double proteinGoal = data.proteinGoal;
          double fatGoal = data.fatGoal;
          
          double calorieProgress = consumedCalories / calorieGoal;
          calorieProgress = calorieProgress > 1 ? 1 : calorieProgress;

          return Column(
            children: [
              AppBar(
                title: Text(formatter.formatDate(selectedDate), style: TextStyle(color: Colors.black)),
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                    icon: Icon(Icons.calendar_month, color: Colors.black),
                    onPressed: _showDatePicker,
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
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
                              "Resumo Diário",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "${consumedCalories.toInt()}",
                                      style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "Calorias Consumidas",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ]
                                ),
                                SizedBox(width: 8),
                                Column(
                                  children: [
                                    Text(
                                      "${(calorieGoal - consumedCalories).toInt()}",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Calorias Faltantes",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ]
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                value: calorieProgress,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                minHeight: 13,
                              ),
                            ),
                            
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircularProgressIndicatorWidget(
                                  consumedCarbs,
                                  carbGoal,
                                  Color(0xFFA7E100),
                                  Color(0xFFC9C9C9)!,
                                  "Carboidratos",
                                ),
                                CircularProgressIndicatorWidget(
                                  consumedProteins,
                                  proteinGoal,
                                  Color(0xFFA7E100),
                                  Color(0xFFC9C9C9)!,
                                  "Proteínas",
                                ),
                                CircularProgressIndicatorWidget(
                                  consumedFats,
                                  fatGoal,
                                  Color(0xFFA7E100),
                                  Color(0xFFC9C9C9)!,
                                  "Gorduras",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      MealPlanner(selectedDate: selectedDate),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Text("Algo deu errado...");
        }
      }
    );
  }
}