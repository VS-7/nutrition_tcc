import 'package:macro_counter/data/dao.dart';
import 'package:macro_counter/models/meal_plan.dart';
import 'package:macro_counter/data/sqflite_database_helper.dart';
import 'package:macro_counter/data/taco_dao.dart';

class MealPlanDao implements Dao<MealPlan> {
  final SqfliteDatabaseHelper _dbHelper = SqfliteDatabaseHelper.instance;
  final TacoDao _tacoDao = TacoDao();

  @override
  Future<int> insert(MealPlan mealPlan) async {
    final db = await _dbHelper.database;
    final mealPlanId = await db.insert('meal_plan', mealPlan.toMap());

    for (var food in mealPlan.foods) {
      await db.insert('meal_plan_food', {
        'mealPlanId': mealPlanId,
        'foodName': food['Nome'],
        'quantity': mealPlan.foodQuantities[food['Nome']] ?? 1.0,
      });
    }

    return mealPlanId;
  }

  @override
  Future<MealPlan?> read(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query('meal_plan', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      final foodMaps = await db.query('meal_plan_food', where: 'mealPlanId = ?', whereArgs: [id]);
      final foods = await Future.wait(
        foodMaps.map((map) => _tacoDao.searchFoodByName(map['foodName'] as String))
      );
      final foodQuantities = {for (var map in foodMaps) map['foodName'] as String: map['quantity'] as double};
      return MealPlan.fromMap(maps.first, foods.expand((i) => i).toList(), foodQuantities);
    }
    return null;
  }

  @override
  Future<List<MealPlan>> readAll() async {
    final db = await _dbHelper.database;
    final mealPlanMaps = await db.query('meal_plan');
    
    return Future.wait(mealPlanMaps.map((mealPlanMap) async {
      final foodMaps = await db.query('meal_plan_food', where: 'mealPlanId = ?', whereArgs: [mealPlanMap['id']]);
      final foods = await Future.wait(
        foodMaps.map((map) => _tacoDao.searchFoodByName(map['foodName'] as String))
      );
      final foodQuantities = {for (var map in foodMaps) map['foodName'] as String: map['quantity'] as double};
      return MealPlan.fromMap(mealPlanMap, foods.expand((i) => i).toList(), foodQuantities);
    }));
  }

  @override
  Future<int> update(MealPlan mealPlan) async {
    final db = await _dbHelper.database;
    await db.delete('meal_plan_food', where: 'mealPlanId = ?', whereArgs: [mealPlan.id]);
    
    for (var food in mealPlan.foods) {
      await db.insert('meal_plan_food', {
        'mealPlanId': mealPlan.id,
        'foodName': food['Nome'],
        'quantity': mealPlan.foodQuantities[food['Nome']] ?? 1.0,
      });
    }

    return await db.update('meal_plan', mealPlan.toMap(), where: 'id = ?', whereArgs: [mealPlan.id]);
  }

  @override
  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete('meal_plan_food', where: 'mealPlanId = ?', whereArgs: [id]);
    return await db.delete('meal_plan', where: 'id = ?', whereArgs: [id]);
  }
}