import 'package:sqflite/sqflite.dart';
import 'package:macro_counter/data/sqflite_database_helper.dart';

class TacoDao {
  final SqfliteDatabaseHelper _databaseHelper = SqfliteDatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> getFoodsByCategory(String category) async {
    final db = await _databaseHelper.tacoDatabase;
    return db.query(category);
  }

  Future<List<Map<String, dynamic>>> getAllFoods() async {
    final db = await _databaseHelper.tacoDatabase;
    List<Map<String, dynamic>> allFoods = [];
    List<Map<String, dynamic>> tables = await db.query('sqlite_master', 
                                         columns: ['Nome'], 
                                         where: 'type = ?', 
                                         whereArgs: ['table']);
    
    for (var table in tables) {
      String tableName = table['name'] as String;
      if (tableName != 'android_metadata' && tableName != 'sqlite_sequence') {
        List<Map<String, dynamic>> foods = await db.query(tableName);
        allFoods.addAll(foods);
      }
    }
    
    return allFoods;
  }

  Future<List<Map<String, dynamic>>> searchFoodByName(String name) async {
    final db = await _databaseHelper.tacoDatabase;
    List<Map<String, dynamic>> results = [];
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
        results.addAll(foods);
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