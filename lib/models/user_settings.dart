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
  final double waterGoal;
  final String profilePictureUrl;

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
    this.waterGoal = 2.0,
    this.profilePictureUrl = '',
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
      'waterGoal': waterGoal,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  UserSettings copyWith({
    String? name,
    double? calorieGoal,
    double? carbGoal,
    double? proteinGoal,
    double? fatGoal,
    bool? onboardingCompleted,
    int? age,
    double? weight,
    double? height,
    String? gender,
    String? activityLevel,
    String? goal,
    double? breakfastCalorieGoal,
    double? lunchCalorieGoal,
    double? dinnerCalorieGoal,
    double? snackCalorieGoal,
    double? waterGoal,
    String? profilePictureUrl,
  }) {
    return UserSettings(
      name: name ?? this.name,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      carbGoal: carbGoal ?? this.carbGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      fatGoal: fatGoal ?? this.fatGoal,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      breakfastCalorieGoal: breakfastCalorieGoal ?? this.breakfastCalorieGoal,
      lunchCalorieGoal: lunchCalorieGoal ?? this.lunchCalorieGoal,
      dinnerCalorieGoal: dinnerCalorieGoal ?? this.dinnerCalorieGoal,
      snackCalorieGoal: snackCalorieGoal ?? this.snackCalorieGoal,
      waterGoal: waterGoal ?? this.waterGoal,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }
}