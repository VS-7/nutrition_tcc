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
    await db.execute(
      "CREATE TABLE IF NOT EXISTS food ( id INTEGER PRIMARY KEY, name TEXT NOT NULL, calories REAL, carbs REAL, proteins REAL, fats REAL, isDeleted BOOLEAN DEFAULT FALSE );"
    );
    await db.execute(
      "CREATE TABLE IF NOT EXISTS meal ( id INTEGER PRIMARY KEY, datetime DATETIME NOT NULL, quantity REAL NOT NULL, foodId INTEGER NOT NULL);"
    );
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meal_plan (
        id INTEGER PRIMARY KEY,
        dateTime DATETIME NOT NULL,
        type INTEGER NOT NULL
    );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS meal_plan_food (
        id INTEGER PRIMARY KEY,
        mealPlanId INTEGER NOT NULL,
        foodName TEXT NOT NULL,
        quantity REAL NOT NULL,
        FOREIGN KEY (mealPlanId) REFERENCES meal_plan(id)
      );
    ''');
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