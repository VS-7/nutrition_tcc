import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_settings.dart';
import 'io_dao.dart';

class UserSettingsDao implements IoDao<UserSettings> {
  @override
  Future<UserSettings?> read() async {
    final prefs = await SharedPreferences.getInstance();
    return UserSettings(
      name: prefs.getString('name') ?? '',
      calorieGoal: prefs.getDouble('calorieGoal') ?? 0,
      carbGoal: prefs.getDouble('carbGoal') ?? 0,
      proteinGoal: prefs.getDouble('proteinGoal') ?? 0,
      fatGoal: prefs.getDouble('fatGoal') ?? 0,
      onboardingCompleted: prefs.getBool('onboardingCompleted') ?? false,
      age: prefs.getInt('age') ?? 0,
      weight: prefs.getDouble('weight') ?? 0,
      height: prefs.getDouble('height') ?? 0,
      gender: prefs.getString('gender') ?? '',
      activityLevel: prefs.getString('activityLevel') ?? '',
      goal: prefs.getString('goal') ?? '',
      breakfastCalorieGoal: prefs.getDouble('breakfastCalorieGoal') ?? 0,
      lunchCalorieGoal: prefs.getDouble('lunchCalorieGoal') ?? 0,
      dinnerCalorieGoal: prefs.getDouble('dinnerCalorieGoal') ?? 0,
      snackCalorieGoal: prefs.getDouble('snackCalorieGoal') ?? 0,
      waterGoal: prefs.getDouble('waterGoal') ?? 2.0,
    );
  }

  @override
  Future<int> insert(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', settings.name);
    await prefs.setDouble('calorieGoal', settings.calorieGoal);
    await prefs.setDouble('carbGoal', settings.carbGoal);
    await prefs.setDouble('proteinGoal', settings.proteinGoal);
    await prefs.setDouble('fatGoal', settings.fatGoal);
    await prefs.setBool('onboardingCompleted', settings.onboardingCompleted);
    await prefs.setInt('age', settings.age);
    await prefs.setDouble('weight', settings.weight);
    await prefs.setDouble('height', settings.height);
    await prefs.setString('gender', settings.gender);
    await prefs.setString('activityLevel', settings.activityLevel);
    await prefs.setString('goal', settings.goal);
    await prefs.setDouble('breakfastCalorieGoal', settings.breakfastCalorieGoal);
    await prefs.setDouble('lunchCalorieGoal', settings.lunchCalorieGoal);
    await prefs.setDouble('dinnerCalorieGoal', settings.dinnerCalorieGoal);
    await prefs.setDouble('snackCalorieGoal', settings.snackCalorieGoal);
    await prefs.setDouble('waterGoal', settings.waterGoal);
    return 1; // Retorna 1 para indicar sucesso
  }

@override
Future<int> update(UserSettings settings) async {
  return insert(settings);
}

@override
Future<int> delete() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  return 1;
  }
}
