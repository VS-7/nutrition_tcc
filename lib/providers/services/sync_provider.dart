import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/sqflite_database_helper.dart';

class SyncProvider with ChangeNotifier {
  final SqfliteDatabaseHelper dbHelper = SqfliteDatabaseHelper.instance;

  Future<String?> upload(String userId) async {
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

      // Atualiza a data da última sincronização
      await db.collection("users").doc(userId).set({
        'lastSync': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));

    } catch (error) {
      debugPrint("Erro no método 'upload' na classe 'SyncProvider': $error");
      return "Ocorreu um erro durante a sincronização. Tente novamente mais tarde.";
    }
    return null;
  }

  Future<String?> download(String userId) async {
    final db = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    await dbHelper.close();

    try {
      // Download do banco de dados principal
      final String dbPath = join(await getDatabasesPath(), 'calorie_counter.db');
      final File dbFile = File(dbPath);
      final storageRef = storage.ref().child('databases/$userId/calorie_counter.db');

      await storageRef.writeToFile(dbFile);

      // Verifica se o usuário existe
      final docSnapshot = await db.collection("users").doc(userId).get();
      if (!docSnapshot.exists) {
        return "Usuário não encontrado";
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
}
