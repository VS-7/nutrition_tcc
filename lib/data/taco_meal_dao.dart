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
      'colesterol': meal.food.colesterol,
      'carboidrato': meal.food.carboidrato,
      'fibra': meal.food.fibra,
      'calcio': meal.food.calcio,
      'magnesio': meal.food.magnesio,
      'manganes': meal.food.manganes,
      'fosforo': meal.food.fosforo,
      'ferro': meal.food.ferro,
      'sodio': meal.food.sodio,
      'potassio': meal.food.potassio,
      'cobre': meal.food.cobre,
      'zinco': meal.food.zinco,
      'retinol': meal.food.retinol,
      'riboflavina': meal.food.riboflavina,
      'vitc': meal.food.vitc,
      'vita': meal.food.vita,
      'vitb1': meal.food.vitb1,
      'vitb2': meal.food.vitb2,
      'vitb3': meal.food.vitb3,
      'vitb6': meal.food.vitb6,
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
          colesterol: maps[i]['colesterol'],
          carboidrato: maps[i]['carboidrato'],
          fibra: maps[i]['fibra'],
          calcio: maps[i]['calcio'],
          magnesio: maps[i]['magnesio'],
          manganes: maps[i]['manganes'],
          fosforo: maps[i]['fosforo'],
          ferro: maps[i]['ferro'],
          sodio: maps[i]['sodio'],
          potassio: maps[i]['potassio'],
          cobre: maps[i]['cobre'],
          zinco: maps[i]['zinco'],
          retinol: maps[i]['retinol'],
          riboflavina: maps[i]['riboflavina'],
          vitc: maps[i]['vitc'],
          vita: maps[i]['vita'],
          vitb1: maps[i]['vitb1'],
          vitb2: maps[i]['vitb2'],
          vitb3: maps[i]['vitb3'],
          vitb6: maps[i]['vitb6'],
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
        'colesterol': meal.food.colesterol,
        'carboidrato': meal.food.carboidrato,
        'fibra': meal.food.fibra,
        'calcio': meal.food.calcio,
        'magnesio': meal.food.magnesio,
        'manganes': meal.food.manganes,
        'fosforo': meal.food.fosforo,
        'ferro': meal.food.ferro,
        'sodio': meal.food.sodio,
        'potassio': meal.food.potassio,
        'cobre': meal.food.cobre,
        'zinco': meal.food.zinco,
        'retinol': meal.food.retinol,
        'riboflavina': meal.food.riboflavina,
        'vitc': meal.food.vitc,
        'vita': meal.food.vita,
        'vitb1': meal.food.vitb1,
        'vitb2': meal.food.vitb2,
        'vitb3': meal.food.vitb3,
        'vitb6': meal.food.vitb6,
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