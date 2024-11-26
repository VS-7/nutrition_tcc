import 'package:sqflite/sqflite.dart';
import '../models/water_consumption.dart';
import 'io_dao.dart';
import 'sqflite_database_helper.dart';

class WaterConsumptionDao implements IoDao<WaterConsumption> {
  final SqfliteDatabaseHelper _databaseHelper;
  final DateTime _selectedDate;

  WaterConsumptionDao(this._databaseHelper, this._selectedDate);

  String get _dateStr {
    return "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
  }

  @override
  Future<WaterConsumption?> read() async {
    final db = await _databaseHelper.database;
    
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'water_consumption',
        where: 'date = ?',
        whereArgs: [_dateStr],
      );
      
      if (maps.isEmpty) {
        final newConsumption = WaterConsumption(
          amount: 0,
          date: _selectedDate,
        );
        await insert(newConsumption);
        return newConsumption;
      }
      return WaterConsumption.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> insert(WaterConsumption item) async {
    final db = await _databaseHelper.database;
    try {
      return await db.insert(
        'water_consumption',
        {
          'amount': item.amount,
          'date': _dateStr,
        },
      );
    } catch (e) {
      return -1;
    }
  }

  @override
  Future<int> update(WaterConsumption item) async {
    final db = await _databaseHelper.database;
    try {
      return await db.update(
        'water_consumption',
        {
          'amount': item.amount,
        },
        where: 'date = ?',
        whereArgs: [_dateStr],
      );
    } catch (e) {
      return -1;
    }
  }

  @override
  Future<int> delete() async {
    final db = await _databaseHelper.database;
    return db.delete(
      'water_consumption',
      where: 'date = ?',
      whereArgs: [_dateStr],
    );
  }
}