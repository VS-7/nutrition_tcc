import 'package:macro_counter/data/database_helper.dart';
import 'package:macro_counter/models/taco_food.dart';
import 'package:macro_counter/models/taco_meal.dart';
import 'package:sqflite/sqflite.dart';

class TacoMealDao {
  final DatabaseHelper _databaseHelper;

  TacoMealDao(this._databaseHelper);

  Future<int> insert(TacoMeal meal) async {
    final db = await _databaseHelper.database;
    return await db.insert('taco_meal', {
      'food_name': meal.food.nome,
      'energia': meal.food.energia,
      'proteina': meal.food.proteina,
      'lipideos': meal.food.lipideos,
      'carboidrato': meal.food.carboidrato,
      'categoria': meal.food.categoria,
      'quantity': meal.quantity,
      'meal_type': meal.mealType,
      'date': meal.date.toIso8601String(),
    });
  }

  Future<List<TacoMeal>> getMealsByDate(DateTime date) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'taco_meal',
      where: 'date LIKE ?',
      whereArgs: ['${date.toIso8601String().split('T')[0]}%'],
    );

    return List.generate(maps.length, (i) {
      return TacoMeal(
        id: maps[i]['id'],
        food: TacoFood(
          nome: maps[i]['food_name'],
          energia: maps[i]['energia'],
          proteina: maps[i]['proteina'],
          lipideos: maps[i]['lipideos'],
          carboidrato: maps[i]['carboidrato'],
          categoria: maps[i]['categoria'],
        ),
        quantity: maps[i]['quantity'],
        mealType: maps[i]['meal_type'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }

  Future<int> update(TacoMeal meal) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'taco_meal',
      {
        'food_name': meal.food.nome,
        'energia': meal.food.energia,
        'proteina': meal.food.proteina,
        'lipideos': meal.food.lipideos,
        'carboidrato': meal.food.carboidrato,
        'categoria': meal.food.categoria,
        'quantity': meal.quantity,
        'meal_type': meal.mealType,
        'date': meal.date.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [meal.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'taco_meal',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}