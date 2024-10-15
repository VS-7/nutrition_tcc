import 'package:flutter/material.dart';
import 'package:macro_counter/data/dao.dart';
import 'package:macro_counter/data/database_helper.dart';
import 'package:macro_counter/data/food_dao.dart';
import 'package:macro_counter/data/io_dao.dart';
import 'package:macro_counter/data/meal_dao.dart';
import 'package:macro_counter/data/shared_preferences_helper.dart';
import 'package:macro_counter/data/sqflite_database_helper.dart';
import 'package:macro_counter/data/user_settings_dao.dart';
import 'package:macro_counter/models/food.dart';
import 'package:macro_counter/models/meal.dart';
import 'package:macro_counter/models/user_settings.dart';
import 'package:macro_counter/providers/food_provider.dart';
import 'package:macro_counter/providers/id_provider_dt.dart';
import 'package:macro_counter/providers/meal_provider.dart';
import 'package:macro_counter/providers/user_settings_provider.dart';
import 'package:macro_counter/screens/scaffold_screen.dart';
import 'package:macro_counter/screens/onboarding_screen.dart';
import 'package:macro_counter/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseHelper sqfliteHelper = SqfliteDatabaseHelper.instance;
    DatabaseHelper sharedPreferencesHelper = SharedPreferencesHelper.instance;

    String foodTableName = "food";
    String mealTableName = "meal";

    Dao<Food> foodDao = FoodDao(sqfliteHelper, foodTableName);
    Dao<Meal> mealDao = MealDao(sqfliteHelper, mealTableName);
    IoDao<UserSettings> userSettingsDao =
        UserSettingsDao(sharedPreferencesHelper);

    FoodProvider foodProvider = FoodProvider(foodDao);
    MealProvider mealProvider = MealProvider(mealDao);
    UserSettingsProvider userSettingsProvider =
        UserSettingsProvider(userSettingsDao);
    IdProviderDt idProvider = IdProviderDt();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => foodProvider),
        ChangeNotifierProvider(create: (ctx) => mealProvider),
        ChangeNotifierProvider(create: (ctx) => userSettingsProvider),
        ChangeNotifierProvider(create: (ctx) => idProvider),
      ],
      child: MaterialApp(
        title: 'Macro Tracker',
        theme: AppTheme.themeData,
        home: FutureBuilder<bool>(
          future: _checkFirstSeen(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.data == true) {
              return WelcomeScreen();
            } else {
              return FutureBuilder<UserSettings?>(
                future: userSettingsProvider.object,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.onboardingCompleted) {
                    return ScaffoldScreen();
                  } else {
                    return OnboardingScreen();
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (!_seen) {
      await prefs.setBool('seen', true);
      return true;
    }

    return false;
  }
}