import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/user_settings.dart';

class UserJsonDataProvider with ChangeNotifier {
  UserJsonDataProvider._privateConstructor();

  static final UserJsonDataProvider _instance = UserJsonDataProvider._privateConstructor();

  factory UserJsonDataProvider() {
    return _instance;
  }

  final String _fileName = 'user_settings.json';

  Future<File> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<void> writeData(UserSettings settings) async {
    try {
      final file = await _getFilePath();
      final Map<String, dynamic> settingsMap = {
        'calorieGoal': settings.calorieGoal,
        'carbGoal': settings.carbGoal,
        'proteinGoal': settings.proteinGoal,
        'fatGoal': settings.fatGoal,
        'onboardingCompleted': settings.onboardingCompleted,
        'age': settings.age,
        'weight': settings.weight,
        'height': settings.height,
        'gender': settings.gender,
        'activityLevel': settings.activityLevel,
        'goal': settings.goal,
        'breakfastCalorieGoal': settings.breakfastCalorieGoal,
        'lunchCalorieGoal': settings.lunchCalorieGoal,
        'dinnerCalorieGoal': settings.dinnerCalorieGoal,
        'snackCalorieGoal': settings.snackCalorieGoal,
      };
      
      String jsonString = json.encode(settingsMap);
      await file.writeAsString(jsonString);
      notifyListeners();
    } catch (e) {
      debugPrint("Erro no método 'writeData' na classe 'UserJsonDataProvider': $e");
    }
  }

  Future<UserSettings?> readData() async {
    try {
      final file = await _getFilePath();
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        final Map<String, dynamic> dataMap = json.decode(jsonString);
        
        return UserSettings(
          calorieGoal: dataMap['calorieGoal'] ?? 2000.0,
          carbGoal: dataMap['carbGoal'] ?? 250.0,
          proteinGoal: dataMap['proteinGoal'] ?? 150.0,
          fatGoal: dataMap['fatGoal'] ?? 67.0,
          onboardingCompleted: dataMap['onboardingCompleted'] ?? false,
          age: dataMap['age'] ?? 0,
          weight: dataMap['weight'] ?? 0.0,
          height: dataMap['height'] ?? 0.0,
          gender: dataMap['gender'] ?? '',
          activityLevel: dataMap['activityLevel'] ?? '',
          goal: dataMap['goal'] ?? '',
          breakfastCalorieGoal: dataMap['breakfastCalorieGoal'] ?? 500.0,
          lunchCalorieGoal: dataMap['lunchCalorieGoal'] ?? 700.0,
          dinnerCalorieGoal: dataMap['dinnerCalorieGoal'] ?? 600.0,
          snackCalorieGoal: dataMap['snackCalorieGoal'] ?? 200.0,
        );
      }
      
      // Criar configurações padrão se o arquivo não existir
      final defaultSettings = UserSettings(
        calorieGoal: 2000.0,
        carbGoal: 250.0,
        proteinGoal: 150.0,
        fatGoal: 67.0,
        breakfastCalorieGoal: 500.0,
        lunchCalorieGoal: 700.0,
        dinnerCalorieGoal: 600.0,
        snackCalorieGoal: 200.0,
      );
      await writeData(defaultSettings);
      return defaultSettings;
    } catch (e) {
      debugPrint("Erro no método 'readData' na classe 'UserJsonDataProvider': $e");
      return null;
    }
  }

  Future<void> deleteData() async {
    try {
      final file = await _getFilePath();
      if (await file.exists()) {
        await file.delete();
        notifyListeners();
        debugPrint("Dados do usuário deletados com sucesso.");
      } else {
        debugPrint("Não há dados do usuário para deletar.");
      }
    } catch (e) {
      debugPrint("Erro no método 'deleteData' na classe 'UserJsonDataProvider': $e");
    }
  }
}
