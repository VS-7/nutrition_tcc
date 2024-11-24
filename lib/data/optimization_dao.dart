import 'package:sqflite/sqflite.dart';
import '../models/optimization_food.dart';
import 'sqflite_database_helper.dart';

class OptimizationDao {
  final SqfliteDatabaseHelper _databaseHelper = SqfliteDatabaseHelper.instance;

  Future<List<OptimizationFood>> getAllOptimizationFoods() async {
    try {
      final db = await _databaseHelper.tacoDatabase;
      final List<Map<String, dynamic>> maps = await db.query(
        'alimentos_otimizacao',
        orderBy: 'nome'
      );
      
      print('Número de alimentos carregados: ${maps.length}');
      
      return List.generate(maps.length, (i) {
        final food = OptimizationFood.fromMap(maps[i]);
        print('Alimento ${i + 1}: ${food.nome}');
        print('  Energia: ${food.energia}');
        print('  Proteína: ${food.proteina}');
        print('  Carboidrato: ${food.carboidrato}');
        print('  Fibra: ${food.fibraAlimentar}');
        return food;
      });
    } catch (e) {
      print('Erro ao carregar alimentos: $e');
      rethrow; // Relança o erro para tratamento na UI
    }
  }

  Future<List<String>> getCategories() async {
    final db = await _databaseHelper.tacoDatabase;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT DISTINCT categoria FROM alimentos_otimizacao ORDER BY categoria'
    );
    return result.map((map) => map['categoria'] as String).toList();
  }

  Future<List<OptimizationFood>> getFoodsByCategory(String category) async {
    final db = await _databaseHelper.tacoDatabase;
    final List<Map<String, dynamic>> maps = await db.query(
      'alimentos_otimizacao',
      where: 'categoria = ?',
      whereArgs: [category],
      orderBy: 'nome'
    );
    return List.generate(maps.length, (i) => OptimizationFood.fromMap(maps[i]));
  }
}