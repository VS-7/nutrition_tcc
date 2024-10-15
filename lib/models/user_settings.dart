class UserSettings {
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

  UserSettings({
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
  });
}