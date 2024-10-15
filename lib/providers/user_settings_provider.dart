import 'package:flutter/material.dart';
import '../data/io_dao.dart';
import '../models/user_settings.dart';
import 'io_object_provider.dart';

class UserSettingsProvider with ChangeNotifier implements IoObjectProvider<UserSettings> {
  final IoDao<UserSettings> userSettingsDao;
  UserSettings? _settings;

  UserSettingsProvider(this.userSettingsDao);

  @override
  Future<UserSettings?> get object async {
    _settings ??= await userSettingsDao.read();
    return _settings;
  }

  @override
  Future<void> addObject(UserSettings object) async {
    await userSettingsDao.insert(object);
    _settings = object;
    notifyListeners();
  }

  @override
  Future<void> updateObject(UserSettings object) async {
    await userSettingsDao.update(object);
    _settings = object;
    notifyListeners();
  }

  @override
  Future<void> deleteObject() async {
    await userSettingsDao.delete();
    _settings = null;
    notifyListeners();
  }
}