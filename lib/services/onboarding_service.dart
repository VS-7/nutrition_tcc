import 'package:macro_counter/models/user_settings.dart';

class OnboardingService {
  double calculateBMR(double weight, double height, int age, String gender) {
    if (gender == 'Masculino') {
      return (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      return (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
  }

  double calculateTDEE(double bmr, String activityLevel) {
    switch (activityLevel) {
      case 'Sedentário':
        return bmr * 1.2;
      case 'Levemente Ativo':
        return bmr * 1.375;
      case 'Moderadamente Ativo':
        return bmr * 1.55;
      case 'Muito Ativo':
        return bmr * 1.725;
      case 'Extremamente Ativo':
        return bmr * 1.9;
      default:
        return bmr;
    }
  }

  double calculateCalorieGoal(double tdee, String goal) {
    switch (goal) {
      case 'Perder Peso':
        return tdee * 0.85; // 15% de déficit calórico
      case 'Ganhar Peso':
        return tdee * 1.15; // 15% de superávit calórico
      default:
        return tdee; // Manter peso
    }
  }

  UserSettings createUserSettings({
    required int age,
    required double weight,
    required double height,
    required String gender,
    required String activityLevel,
    required String goal,
  }) {
    double bmr = calculateBMR(weight, height, age, gender);
    double tdee = calculateTDEE(bmr, activityLevel);
    double calorieGoal = calculateCalorieGoal(tdee, goal);

    // Calcular as metas calóricas para cada refeição
    double breakfastCalorieGoal = calorieGoal * 0.25; // 25% para o café da manhã
    double lunchCalorieGoal = calorieGoal * 0.30; // 30% para o almoço
    double dinnerCalorieGoal = calorieGoal * 0.30; // 30% para o jantar
    double snackCalorieGoal = calorieGoal * 0.15; // 15% para o lanche

    // Ajustar a diferença, se houver
    double totalMealCalories = breakfastCalorieGoal + lunchCalorieGoal + dinnerCalorieGoal + snackCalorieGoal;
    if (totalMealCalories != calorieGoal) {
      double difference = calorieGoal - totalMealCalories;
      double adjustment = difference / 4;
      breakfastCalorieGoal += adjustment;
      lunchCalorieGoal += adjustment;
      dinnerCalorieGoal += adjustment;
      snackCalorieGoal += adjustment;
    }

    return UserSettings(
      calorieGoal: calorieGoal,
      carbGoal: calorieGoal * 0.5 / 4, // 50% das calorias de carboidratos
      proteinGoal: calorieGoal * 0.2 / 4, // 30% das calorias de proteínas
      fatGoal: calorieGoal * 0.3 / 9, // 20% das calorias de gorduras
      onboardingCompleted: true,
      age: age,
      weight: weight,
      height: height,
      gender: gender,
      activityLevel: activityLevel,
      goal: goal,
      breakfastCalorieGoal: breakfastCalorieGoal,
      lunchCalorieGoal: lunchCalorieGoal,
      dinnerCalorieGoal: dinnerCalorieGoal,
      snackCalorieGoal: snackCalorieGoal,
    );
  }
}