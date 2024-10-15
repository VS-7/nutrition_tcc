import 'package:macro_counter/data/database_helper.dart';
import 'package:macro_counter/data/io_dao.dart';
import 'package:macro_counter/models/user_settings.dart';

class UserSettingsDao implements IoDao<UserSettings> {
  final DatabaseHelper databaseHelper;

  UserSettingsDao(this.databaseHelper);

  @override
  Future<int> insert(UserSettings item) async {
    final database = await databaseHelper.database;
    try {
      await database.setDouble("calorieGoal", item.calorieGoal);
      await database.setDouble("carbGoal", item.carbGoal);
      await database.setDouble("proteinGoal", item.proteinGoal);
      await database.setDouble("fatGoal", item.fatGoal);
      await database.setBool("onboardingCompleted", item.onboardingCompleted);
      await database.setInt("age", item.age);
      await database.setDouble("weight", item.weight);
      await database.setDouble("height", item.height);
      await database.setString("gender", item.gender);
      await database.setString("activityLevel", item.activityLevel);
      await database.setString("goal", item.goal);
      return 1;
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<UserSettings?> read() async {
    final database = await databaseHelper.database;
    final double calorieGoal = database.getDouble("calorieGoal") ?? 2917;
    final double carbGoal = database.getDouble("carbGoal") ?? 255;
    final double proteinGoal = database.getDouble("proteinGoal") ?? 150;
    final double fatGoal = database.getDouble("fatGoal") ?? 138;
    final bool onboardingCompleted = database.getBool("onboardingCompleted") ?? false;
    final int age = database.getInt("age") ?? 0;
    final double weight = database.getDouble("weight") ?? 0;
    final double height = database.getDouble("height") ?? 0;
    final String gender = database.getString("gender") ?? "";
    final String activityLevel = database.getString("activityLevel") ?? "";
    final String goal = database.getString("goal") ?? "";

    return UserSettings(
      calorieGoal: calorieGoal,
      carbGoal: carbGoal,
      proteinGoal: proteinGoal,
      fatGoal: fatGoal,
      onboardingCompleted: onboardingCompleted,
      age: age,
      weight: weight,
      height: height,
      gender: gender,
      activityLevel: activityLevel,
      goal: goal,
    );
  }
}