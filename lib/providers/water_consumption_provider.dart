import 'package:flutter/material.dart';
import '../data/water_consumption_dao.dart';
import '../data/sqflite_database_helper.dart';
import '../models/water_consumption.dart';
import '../data/io_dao.dart';
import 'io_object_provider.dart';

class WaterConsumptionProvider with ChangeNotifier implements IoObjectProvider<WaterConsumption> {
  final SqfliteDatabaseHelper _databaseHelper;
  DateTime _selectedDate = DateTime.now();
  WaterConsumption? _waterConsumption;
  late IoDao<WaterConsumption> _dao;

  WaterConsumptionProvider(this._databaseHelper) {
    _init();
  }

  Future<void> _init() async {
    _dao = WaterConsumptionDao(_databaseHelper, _selectedDate);
    try {
      _waterConsumption = await _dao.read();
    } catch (e) {
      // Silently handle error
    }
    notifyListeners();
  }

  @override
  IoDao<WaterConsumption> get dao => _dao;

  @override
  Future<WaterConsumption?> get object async {
    try {
      if (_waterConsumption == null) {
        _waterConsumption = await _dao.read();
      }
      return _waterConsumption;
    } catch (e) {
      return null;
    }
  }

  set selectedDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    _selectedDate = normalizedDate;
    _waterConsumption = null;
    _dao = WaterConsumptionDao(_databaseHelper, normalizedDate);
    notifyListeners();
  }

  double get consumedWater {
    return _waterConsumption?.amount ?? 0.0;
  }

  @override
  Future<void> addObject(WaterConsumption object) async {
    await _dao.insert(object);
    _waterConsumption = object;
    notifyListeners();
  }

  @override
  Future<void> updateObject(WaterConsumption object) async {
    await _dao.update(object);
    _waterConsumption = object;
    notifyListeners();
  }

  @override
  Future<void> deleteObject() async {
    await _dao.delete();
    _waterConsumption = null;
    notifyListeners();
  }

  Future<void> addWater(double amount) async {
    try {
      final currentAmount = consumedWater;
      final newConsumption = WaterConsumption(
        amount: currentAmount + amount,
        date: _selectedDate,
      );
      
      if (_waterConsumption == null) {
        await addObject(newConsumption);
      } else {
        await updateObject(newConsumption);
      }
      
      _waterConsumption = await _dao.read();
      notifyListeners();
    } catch (e) {
      // Silently handle error
    }
  }

  Future<void> removeWater(double amount) async {
    final currentAmount = consumedWater;
    if (currentAmount >= amount) {
      final newConsumption = WaterConsumption(
        amount: currentAmount - amount,
        date: _selectedDate,
      );
      await updateObject(newConsumption);
    }
  }
}