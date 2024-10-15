import 'package:flutter/material.dart';
import 'package:macro_counter/models/meal.dart';
import 'package:macro_counter/providers/food_provider.dart';
import 'package:macro_counter/providers/meal_provider.dart';
import 'package:macro_counter/providers/user_settings_provider.dart';
import 'package:macro_counter/utils/date_formatter.dart';
import 'package:macro_counter/widgets/meal_card.dart';
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

  Map<String, double> getDailyTotal(
      FoodProvider provider, List<Meal> mealList) {
    double calorie = 0;
    double carb = 0;
    double protein = 0;
    double fat = 0;
    mealList.forEach((meal) {
      calorie += meal.quantity * provider.getObject(meal.foodId)!.calories;
      carb += meal.quantity * provider.getObject(meal.foodId)!.carbs;
      protein += meal.quantity * provider.getObject(meal.foodId)!.proteins;
      fat += meal.quantity * provider.getObject(meal.foodId)!.fats;
    });
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

    List<Meal> mealList =
        Provider.of<MealProvider>(context).filterMealsByDay(selectedDate);

    final foodProvider = Provider.of<FoodProvider>(context);
    Map<String, double> consumedMacros = getDailyTotal(foodProvider, mealList);
    double consumedCalories = consumedMacros['calorie']!;
    double consumedCarbs = consumedMacros['carb']!;
    double consumendProteins = consumedMacros['protein']!;
    double consumedFats = consumedMacros['fat']!;

    void _showDatePicker() {
      showDatePicker(
              context: context,
              firstDate: DateTime.now().subtract(Duration(days: 365)),
              lastDate: DateTime.now(),
              initialDate: selectedDate)
          .then(
        (value) {
          setState(
            () {
              selectedDate = value ?? selectedDate;
            },
          );
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
                              consumendProteins,
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
                  
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: mealList.length,
                      itemBuilder: (context, index) {
                        return MealCard(mealList[index],
                            foodProvider.getObject(mealList[index].foodId));
                      },
                    ),
                
                  ],
                ),
              ),
                ),
             ],
              );
            
          } else {
            return Text("Algo deu errado...");
          }
        });
  }
}