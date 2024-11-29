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
      final Map<String, dynamic> settingsMap = settings.toMap();
      
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
          name: dataMap['name'] ?? '',
          calorieGoal: (dataMap['calorieGoal'] ?? 2000.0).toDouble(),
          carbGoal: (dataMap['carbGoal'] ?? 250.0).toDouble(),
          proteinGoal: (dataMap['proteinGoal'] ?? 150.0).toDouble(),
          fatGoal: (dataMap['fatGoal'] ?? 67.0).toDouble(),
          onboardingCompleted: dataMap['onboardingCompleted'] ?? false,
          age: dataMap['age'] ?? 0,
          weight: (dataMap['weight'] ?? 0.0).toDouble(),
          height: (dataMap['height'] ?? 0.0).toDouble(),
          gender: dataMap['gender'] ?? '',
          activityLevel: dataMap['activityLevel'] ?? '',
          goal: dataMap['goal'] ?? '',
          breakfastCalorieGoal: (dataMap['breakfastCalorieGoal'] ?? 500.0).toDouble(),
          lunchCalorieGoal: (dataMap['lunchCalorieGoal'] ?? 700.0).toDouble(),
          dinnerCalorieGoal: (dataMap['dinnerCalorieGoal'] ?? 600.0).toDouble(),
          snackCalorieGoal: (dataMap['snackCalorieGoal'] ?? 200.0).toDouble(),
          waterGoal: (dataMap['waterGoal'] ?? 2.0).toDouble(),
          profilePictureUrl: dataMap['profilePictureUrl'] ?? '',
        );
      }
      
      // Criar configurações padrão se o arquivo não existir
      final defaultSettings = UserSettings(
        name: 'Usuário',
        calorieGoal: 2000.0,
        carbGoal: 250.0,
        proteinGoal: 150.0,
        fatGoal: 67.0,
        breakfastCalorieGoal: 500.0,
        lunchCalorieGoal: 700.0,
        dinnerCalorieGoal: 600.0,
        snackCalorieGoal: 200.0,
        waterGoal: 2.0,
        profilePictureUrl: '',
      );
      await writeData(defaultSettings);
      return defaultSettings;
    } catch (e) {
      debugPrint("Erro no método 'readData' na classe 'UserJsonDataProvider': $e");
      return null;
    }
  }

  Future<void> updateFromCloud(Map<String, dynamic> cloudData) async {
    try {
      final UserSettings settings = UserSettings(
        name: cloudData['name'] ?? '',
        calorieGoal: (cloudData['calorieGoal'] ?? 2000.0).toDouble(),
        carbGoal: (cloudData['carbGoal'] ?? 250.0).toDouble(),
        proteinGoal: (cloudData['proteinGoal'] ?? 150.0).toDouble(),
        fatGoal: (cloudData['fatGoal'] ?? 67.0).toDouble(),
        onboardingCompleted: cloudData['onboardingCompleted'] ?? false,
        age: cloudData['age'] ?? 0,
        weight: (cloudData['weight'] ?? 0.0).toDouble(),
        height: (cloudData['height'] ?? 0.0).toDouble(),
        gender: cloudData['gender'] ?? '',
        activityLevel: cloudData['activityLevel'] ?? '',
        goal: cloudData['goal'] ?? '',
        breakfastCalorieGoal: (cloudData['breakfastCalorieGoal'] ?? 500.0).toDouble(),
        lunchCalorieGoal: (cloudData['lunchCalorieGoal'] ?? 700.0).toDouble(),
        dinnerCalorieGoal: (cloudData['dinnerCalorieGoal'] ?? 600.0).toDouble(),
        snackCalorieGoal: (cloudData['snackCalorieGoal'] ?? 200.0).toDouble(),
        waterGoal: (cloudData['waterGoal'] ?? 2.0).toDouble(),
        profilePictureUrl: cloudData['profilePictureUrl'] ?? '',
      );
      
      await writeData(settings);
    } catch (e) {
      debugPrint("Erro no método 'updateFromCloud' na classe 'UserJsonDataProvider': $e");
      throw Exception('Falha ao atualizar dados da nuvem');
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
