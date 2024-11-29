import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/sqflite_database_helper.dart';
import '../../models/user_settings.dart';
import '../../providers/services/user_json_data_provider.dart';
import '../../providers/user_settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class SyncProvider with ChangeNotifier {
  final SqfliteDatabaseHelper dbHelper = SqfliteDatabaseHelper.instance;

  Future<String?> upload(String userId, UserSettings settings) async {
    final db = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    await dbHelper.close();

    try {
      // Upload do banco de dados principal
      final String dbPath = join(await getDatabasesPath(), 'calorie_counter.db');
      final File dbFile = File(dbPath);
      final storageRef = storage.ref().child('databases/$userId/calorie_counter.db');
      
      // Inicia o upload do arquivo
      storageRef.putFile(dbFile).then((_) {}).catchError((e) {});

      // Verifica se o upload foi concluído
      for (int i = 0; i < 15; i++) {
        await Future.delayed(const Duration(seconds: 5));
        try {
          await storageRef.getDownloadURL();
          break;
        } catch (e) {
          if (i == 14) {
            return "Erro durante o upload do arquivo: $e";
          }
        }
      }

      // Atualiza as informações do usuário
      await db.collection("users").doc(userId).set({
        ...settings.toMap(),  // Adiciona todas as configurações do usuário
        'lastSync': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));

    } catch (error) {
      debugPrint("Erro no método 'upload' na classe 'SyncProvider': $error");
      return "Ocorreu um erro durante a sincronização. Tente novamente mais tarde.";
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    final db = FirebaseFirestore.instance;
    try {
      final docSnapshot = await db.collection("users").doc(userId).get();
      if (!docSnapshot.exists) return null;
      
      return docSnapshot.data();
    } catch (error) {
      debugPrint("Erro no método 'getUserData' na classe 'SyncProvider': $error");
      return null;
    }
  }

  Future<String?> download(String userId, BuildContext context) async {
    final db = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    await dbHelper.close();

    try {
      // Download do banco de dados principal
      final String dbPath = join(await getDatabasesPath(), 'calorie_counter.db');
      final File dbFile = File(dbPath);
      final storageRef = storage.ref().child('databases/$userId/calorie_counter.db');

      await storageRef.writeToFile(dbFile);

      // Verifica se o usuário existe e atualiza dados locais
      final docSnapshot = await db.collection("users").doc(userId).get();
      if (!docSnapshot.exists) {
        return "Usuário não encontrado";
      }

      // Atualiza os dados locais com os dados da nuvem
      final userData = docSnapshot.data();
      if (userData != null) {
        // Atualiza UserJsonDataProvider
        final userJsonDataProvider = Provider.of<UserJsonDataProvider>(context, listen: false);
        await userJsonDataProvider.updateFromCloud(userData);

        // Atualiza UserSettingsProvider
        final userSettingsProvider = Provider.of<UserSettingsProvider>(context, listen: false);
        final newSettings = UserSettings(
          name: userData['name'] ?? '',
          calorieGoal: (userData['calorieGoal'] ?? 2000.0).toDouble(),
          carbGoal: (userData['carbGoal'] ?? 250.0).toDouble(),
          proteinGoal: (userData['proteinGoal'] ?? 150.0).toDouble(),
          fatGoal: (userData['fatGoal'] ?? 67.0).toDouble(),
          onboardingCompleted: userData['onboardingCompleted'] ?? false,
          age: userData['age'] ?? 0,
          weight: (userData['weight'] ?? 0.0).toDouble(),
          height: (userData['height'] ?? 0.0).toDouble(),
          gender: userData['gender'] ?? '',
          activityLevel: userData['activityLevel'] ?? '',
          goal: userData['goal'] ?? '',
          breakfastCalorieGoal: (userData['breakfastCalorieGoal'] ?? 500.0).toDouble(),
          lunchCalorieGoal: (userData['lunchCalorieGoal'] ?? 700.0).toDouble(),
          dinnerCalorieGoal: (userData['dinnerCalorieGoal'] ?? 600.0).toDouble(),
          snackCalorieGoal: (userData['snackCalorieGoal'] ?? 200.0).toDouble(),
          waterGoal: (userData['waterGoal'] ?? 2.0).toDouble(),
          profilePictureUrl: userData['profilePictureUrl'] ?? '',
        );
        await userSettingsProvider.updateObject(newSettings);
      }

      // Atualiza a data da última sincronização
      await db.collection("users").doc(userId).set({
        'lastSync': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));

    } catch (error) {
      debugPrint("Erro no método 'download' na classe 'SyncProvider': $error");
      return "Ocorreu um erro durante o download. Tente novamente mais tarde.";
    }
    return null;
  }

  Future<DateTime?> getLastSync(String userId) async {
    final db = FirebaseFirestore.instance;
    try {
      final docSnapshot = await db.collection("users").doc(userId).get();
      if (!docSnapshot.exists) return null;
      
      final userData = docSnapshot.data();
      if (userData != null && userData.containsKey('lastSync')) {
        return DateTime.parse(userData['lastSync']);
      }
    } catch (error) {
      debugPrint("Erro no método 'getLastSync' na classe 'SyncProvider': $error");
    }
    return null;
  }

  Future<String?> uploadProfilePicture(String userId, XFile imageFile) async {
    final storage = FirebaseStorage.instance;
    final db = FirebaseFirestore.instance;

    try {
      // Delete old profile picture if it exists
      final userData = await getUserData(userId);
      if (userData != null && userData['profilePictureUrl'] != null && userData['profilePictureUrl'].isNotEmpty) {
        try {
          await storage.refFromURL(userData['profilePictureUrl']).delete();
        } catch (e) {
          debugPrint("Error deleting old profile picture: $e");
        }
      }

      // Upload new profile picture
      final storageRef = storage.ref().child('profile_pictures/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(File(imageFile.path));
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Update Firestore with new URL
      await db.collection("users").doc(userId).update({
        'profilePictureUrl': downloadUrl,
      });

      return downloadUrl;
    } catch (error) {
      debugPrint("Error uploading profile picture: $error");
      return null;
    }
  }
}
