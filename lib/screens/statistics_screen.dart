import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macro_counter/providers/taco_meal_provider.dart';
import 'package:macro_counter/providers/user_settings_provider.dart';
import 'package:macro_counter/utils/date_formatter.dart';
import 'package:macro_counter/widgets/background_container.dart';
import 'package:macro_counter/models/taco_meal.dart';
import 'package:macro_counter/widgets/statistics_screen_widgets/weekly_progress_bar.dart';
import 'dart:ui';

class StatisticsScreen extends StatelessWidget {
  final DateTime selectedDate;

  const StatisticsScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<TacoMealProvider>(context);
    final settingsProvider = Provider.of<UserSettingsProvider>(context);
    final dateFormatter = DateFormatter();

    return FutureBuilder(
      future: Future.wait([
        mealProvider.getWeeklyMeals(selectedDate),
        settingsProvider.object,
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final weeklyMeals = snapshot.data![0] as List<TacoMeal>;
          final userSettings = snapshot.data![1];

          final weeklyStats = _calculateWeeklyStats(weeklyMeals);
          final calorieProgress = weeklyStats['calories']! / (userSettings.calorieGoal * 7);
          final carbProgress = weeklyStats['carbs']! / (userSettings.carbGoal * 7);
          final proteinProgress = weeklyStats['proteins']! / (userSettings.proteinGoal * 7);
          final fatProgress = weeklyStats['fats']! / (userSettings.fatGoal * 7);

          return BackgroundContainer(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  // Parte fixa (não rolável)
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/daily_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'ACOMPANHAMENTO SEMANAL',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '7 Dias • ${dateFormatter.formatDate(selectedDate.subtract(Duration(days: 6)))} - ${dateFormatter.formatDate(selectedDate)}',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMacroProgress('Carboidratos', carbProgress, Color(0xFFA7E100), '🌾'),
                            _buildMacroProgress('Proteínas', proteinProgress, Color(0xFFA7E100), '🍗'),
                            _buildMacroProgress('Gorduras', fatProgress, Color(0xFFA7E100), '🥑'),
                          ],
                        ),
                        SizedBox(height: 16),
                        //Text('Calorias', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: calorieProgress,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA7E100)),
                            minHeight: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Parte rolável
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          WeeklyProgressBar(
                            weeklyData: weeklyStats['dailyCalories']!,
                            goal: userSettings.calorieGoal,
                            title: 'Calorias Semanais',
                          ),
                          WeeklyProgressBar(
                            weeklyData: weeklyStats['dailyCarbs']!,
                            goal: userSettings.carbGoal,
                            title: 'Carboidratos Semanais',
                          ),
                          WeeklyProgressBar(
                            weeklyData: weeklyStats['dailyProteins']!,
                            goal: userSettings.proteinGoal,
                            title: 'Proteínas Semanais',
                          ),
                          WeeklyProgressBar(
                            weeklyData: weeklyStats['dailyFats']!,
                            goal: userSettings.fatGoal,
                            title: 'Gorduras Semanais',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text("Algo deu errado...");
        }
      },
    );
  }

  Widget _buildMacroProgress(String label, double progress, Color color, String emoji) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: EdgeInsets.all(10),
          width: 108,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border(
              top: BorderSide(color: Colors.white30, width: 1),
              left: BorderSide(color: Colors.white30, width: 1),
              right: BorderSide(color: Colors.white30, width: 1.5),
              bottom: BorderSide(color: Colors.white30, width: 1.5),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                emoji,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _calculateWeeklyStats(List<TacoMeal> meals) {
    List<double> dailyCalories = List.filled(7, 0);
    List<double> dailyCarbs = List.filled(7, 0);
    List<double> dailyProteins = List.filled(7, 0);
    List<double> dailyFats = List.filled(7, 0);

    for (var meal in meals) {
      int dayIndex = meal.date.weekday - 1;
      dailyCalories[dayIndex] += meal.food.energia * meal.quantity;
      dailyCarbs[dayIndex] += meal.food.carboidrato * meal.quantity;
      dailyProteins[dayIndex] += meal.food.proteina * meal.quantity;
      dailyFats[dayIndex] += meal.food.lipideos * meal.quantity;
    }

    return {
      'dailyCalories': dailyCalories,
      'dailyCarbs': dailyCarbs,
      'dailyProteins': dailyProteins,
      'dailyFats': dailyFats,
      'calories': dailyCalories.reduce((a, b) => a + b),
      'carbs': dailyCarbs.reduce((a, b) => a + b),
      'proteins': dailyProteins.reduce((a, b) => a + b),
      'fats': dailyFats.reduce((a, b) => a + b),
    };
  }
}
