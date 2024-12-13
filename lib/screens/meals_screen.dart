import 'package:flutter/material.dart';
import 'package:macro_counter/models/taco_meal.dart';
import 'package:macro_counter/providers/user_settings_provider.dart';
import 'package:macro_counter/providers/taco_meal_provider.dart';
import 'package:macro_counter/utils/date_formatter.dart';
import 'package:macro_counter/widgets/circular_progress_indicator.dart';
import 'package:macro_counter/widgets/meals_screen_widgets/meal_planner.dart';
import 'package:macro_counter/widgets/meals_screen_widgets/daily_summary_widget.dart';
import 'package:macro_counter/widgets/meals_screen_widgets/meal_recommendation_widget.dart';
import 'package:provider/provider.dart';
import 'package:macro_counter/screens/statistics_screen.dart';
import 'package:macro_counter/widgets/meals_screen_widgets/water_tracker_widget.dart';
import 'package:macro_counter/widgets/meals_screen_widgets/notes_widget.dart';
import 'package:macro_counter/providers/water_consumption_provider.dart';
import 'package:macro_counter/providers/note_provider.dart';
import '../providers/widget_order_provider.dart';
import '../dialogs/widget_order_bottom_sheet.dart';

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
      final context = this.context;
      Provider.of<TacoMealProvider>(context, listen: false).loadMeals(selectedDate);
      Provider.of<WaterConsumptionProvider>(context, listen: false).selectedDate = selectedDate;
      Provider.of<NoteProvider>(context, listen: false).selectedDate = selectedDate;
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
                child: Consumer<WidgetOrderProvider>(
                  builder: (context, orderProvider, child) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          ...orderProvider.widgetOrder.map((widgetId) {
                            switch (widgetId) {
                              case 'daily_summary':
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StatisticsScreen(
                                            selectedDate: selectedDate
                                          ),
                                        ),
                                      ),
                                      child: DailySummaryWidget(
                                        consumedCalories: consumedCalories,
                                        calorieGoal: calorieGoal,
                                        consumedCarbs: consumedCarbs,
                                        carbGoal: carbGoal,
                                        consumedProteins: consumedProteins,
                                        proteinGoal: proteinGoal,
                                        consumedFats: consumedFats,
                                        fatGoal: fatGoal,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              case 'meal_recommendation':
                                return Column(
                                  children: [
                                    MealRecommendationWidget(),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              case 'meal_planner':
                                return Column(
                                  children: [
                                    MealPlanner(selectedDate: selectedDate),
                                    const SizedBox(height: 30),
                                  ],
                                );
                              case 'water_tracker':
                                return Column(
                                  children: [
                                    WaterTrackerWidget(selectedDate: selectedDate),
                                    const SizedBox(height: 30),
                                  ],
                                );
                              case 'notes':
                                return Column(
                                  children: [
                                    NotesWidget(selectedDate: selectedDate),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              default:
                                return const SizedBox.shrink();
                            }
                          }).toList(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton.icon(
                              onPressed: _showWidgetOrderSheet,
                              label: Text('Customizar Diário'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                side: BorderSide(color: Colors.black, width: 2),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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

  void _showDatePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(80)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Selecione uma data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, color: Colors.white),
                ),
              ),
              Expanded(
                child: Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      surface: Colors.grey[900]!,
                      onSurface: Colors.white,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFFA7E100),
                      ),
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: selectedDate,
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now(),
                    onDateChanged: (DateTime value) {
                      setState(() {
                        selectedDate = value;
                      });
                      final context = this.context;
                      Provider.of<TacoMealProvider>(context, listen: false).loadMeals(selectedDate);
                      Provider.of<WaterConsumptionProvider>(context, listen: false).selectedDate = selectedDate;
                      Provider.of<NoteProvider>(context, listen: false).selectedDate = selectedDate;
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 5,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }

  void _showWidgetOrderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const WidgetOrderBottomSheet(),
    );
  }
}
