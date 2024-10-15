import 'package:sqflite/sqflite.dart';
import 'package:macro_counter/data/sqflite_database_helper.dart';
import '../models/taco_food.dart';

class TacoDao {
  final SqfliteDatabaseHelper _databaseHelper = SqfliteDatabaseHelper.instance;

  Future<List<TacoFood>> getFoodsByCategory(String category) async {
    final db = await _databaseHelper.tacoDatabase;
    final List<Map<String, dynamic>> maps = await db.query(category);
    return List.generate(maps.length, (i) {
      return TacoFood.fromMap(maps[i], category);
    });
  }

  Future<List<TacoFood>> getAllFoods() async {
    final db = await _databaseHelper.tacoDatabase;
    List<TacoFood> allFoods = [];
    List<Map<String, dynamic>> tables = await db.query('sqlite_master', 
                                         columns: ['name'], 
                                         where: 'type = ?', 
                                         whereArgs: ['table']);
    
    for (var table in tables) {
      String tableName = table['name'] as String;
      if (tableName != 'android_metadata' && tableName != 'sqlite_sequence') {
        List<Map<String, dynamic>> foods = await db.query(tableName);
        allFoods.addAll(foods.map((food) => TacoFood.fromMap(food, tableName)));
      }
    }
    
    return allFoods;
  }

  Future<List<TacoFood>> searchFoodByName(String name) async {
    final db = await _databaseHelper.tacoDatabase;
    List<TacoFood> results = [];
    List<Map<String, dynamic>> tables = await db.query('sqlite_master', 
                                         columns: ['name'], 
                                         where: 'type = ?', 
                                         whereArgs: ['table']);
    
    for (var table in tables) {
      String tableName = table['name'] as String;
      if (tableName != 'android_metadata' && tableName != 'sqlite_sequence') {
        List<Map<String, dynamic>> foods = await db.query(
          tableName,
          where: 'Nome LIKE ?',
          whereArgs: ['%$name%'],
        );
        results.addAll(foods.map((food) => TacoFood.fromMap(food, tableName)));
      }
    }
    
    return results;
  }

  Future<List<String>> getCategories() async {
    final db = await _databaseHelper.tacoDatabase;
    List<Map<String, dynamic>> tables = await db.query('sqlite_master', 
                                                       columns: ['name'], 
                                                       where: 'type = ?', 
                                                       whereArgs: ['table']);
    return tables
        .map((table) => table['name'] as String)
        .where((name) => name != 'android_metadata' && name != 'sqlite_sequence')
        .toList();
  }
}