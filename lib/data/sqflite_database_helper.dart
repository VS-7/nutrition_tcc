import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:macro_counter/data/database_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';

class SqfliteDatabaseHelper implements DatabaseHelper {
  static const String _databaseName = "calorie_counter.db";
  static const String _tacoDatabaseName = "taco.db";
  static final SqfliteDatabaseHelper instance = SqfliteDatabaseHelper._privateConstructor();
  Database? _database;
  Database? _tacoDatabase;

  SqfliteDatabaseHelper._privateConstructor();

  @override
  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<Database> initTacoDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _tacoDatabaseName);

    if (!await databaseExists(path)) {
      // Copy from asset
      ByteData data = await rootBundle.load(join('assets', 'databases', _tacoDatabaseName));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return openDatabase(path, readOnly: true);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE IF NOT EXISTS taco_meal (
        id INTEGER PRIMARY KEY AUTOINCREMENT, food_name TEXT NOT NULL, energia REAL, proteina REAL, lipideos REAL, colesterol REAL, carboidrato REAL, fibra REAL, calcio REAL, magnesio REAL, manganes REAL, fosforo REAL, ferro REAL, sodio REAL, potassio REAL, cobre REAL, zinco REAL, retinol REAL, riboflavina REAL, vitc REAL, vita REAL, vitb1 REAL, vitb2 REAL, vitb3 REAL, vitb6 REAL, categoria TEXT, quantity REAL NOT NULL, meal_type TEXT NOT NULL, date TEXT NOT NULL
      );
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS water_consumption (
        id INTEGER PRIMARY KEY AUTOINCREMENT, amount REAL NOT NULL, date TEXT NOT NULL
      );
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT NOT NULL, mood TEXT NOT NULL, date TEXT NOT NULL
      );
    """);
  }

  @override
  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> get tacoDatabase async {
    _tacoDatabase ??= await initTacoDatabase();
    return _tacoDatabase!;
  }

  @override
  Future<void> close() async {
    await _database?.close();
    await _tacoDatabase?.close();
    _database = null;
    _tacoDatabase = null;
  }
}