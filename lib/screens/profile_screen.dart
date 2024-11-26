import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/services/firebase_auth_provider.dart';
import '../providers/user_settings_provider.dart';
import '../providers/taco_meal_provider.dart';
import '../dialogs/sync_bottom_sheet.dart';
import '../models/user_settings.dart';
import '../models/taco_meal.dart';
import '../widgets/profile_screen_widgets/user_goals_widget.dart';
import '../widgets/profile_screen_widgets/profile_card_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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

  void _showLoginDialog(BuildContext context) {
    Navigator.pushNamed(context, '/auth');
  }

  void _showSyncDialog(BuildContext context, bool isSaving) {
    showDialog(
      context: context,
      builder: (context) => SyncDialog(isSaving),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<TacoMealProvider>(context);
    final settingsProvider = Provider.of<UserSettingsProvider>(context);
    final authProvider = Provider.of<FirebaseAuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Consumer<UserSettingsProvider>(
                builder: (context, userSettingsProvider, child) {
                  return FutureBuilder<UserSettings?>(
                    future: userSettingsProvider.object,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erro ao carregar dados do usuário');
                      } else if (snapshot.hasData) {
                        List<TacoMeal> mealList = mealProvider.meals.where((meal) =>
                          meal.date.year == DateTime.now().year &&
                          meal.date.month == DateTime.now().month &&
                          meal.date.day == DateTime.now().day
                        ).toList();

                        Map<String, double> consumedMacros = getDailyTotal(mealList);
                        double consumedCalories = consumedMacros['calorie']!;

                        return Column(
                          children: [
                            ProfileCardWidget(
                              settings: snapshot.data!,
                              caloriesConsumed: consumedCalories,
                              isLoggedIn: authProvider.user != null,
                              onLoginTap: () => _showLoginDialog(context),
                              onBackupTap: () => _showSyncDialog(context, true),
                              onRestoreTap: () => _showSyncDialog(context, false),
                              onLogoutTap: () async {
                                await authProvider.signOut();
                              },
                            ),
                            SizedBox(height: 20),
                            UserGoalsWidget(settings: snapshot.data!),
                          ],
                        );
                      } else {
                        return Text('Nenhum dado de usuário encontrado');
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
