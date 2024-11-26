class UserSettings {
  final String name;
  final double calorieGoal;
  final double carbGoal;
  final double proteinGoal;
  final double fatGoal;
  final bool onboardingCompleted;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final String activityLevel;
  final String goal;
  final double breakfastCalorieGoal;
  final double lunchCalorieGoal;
  final double dinnerCalorieGoal;
  final double snackCalorieGoal;

  UserSettings({
    this.name = '',
    required this.calorieGoal,
    required this.carbGoal,
    required this.proteinGoal,
    required this.fatGoal,
    this.onboardingCompleted = false,
    this.age = 0,
    this.weight = 0,
    this.height = 0,
    this.gender = '',
    this.activityLevel = '',
    this.goal = '',
    required this.breakfastCalorieGoal,
    required this.lunchCalorieGoal,
    required this.dinnerCalorieGoal,
    required this.snackCalorieGoal,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calorieGoal': calorieGoal,
      'carbGoal': carbGoal,
      'proteinGoal': proteinGoal,
      'fatGoal': fatGoal,
      'onboardingCompleted': onboardingCompleted,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'activityLevel': activityLevel,
      'goal': goal,
      'breakfastCalorieGoal': breakfastCalorieGoal,
      'lunchCalorieGoal': lunchCalorieGoal,
      'dinnerCalorieGoal': dinnerCalorieGoal,
      'snackCalorieGoal': snackCalorieGoal,
    };
  }
}