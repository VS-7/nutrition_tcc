import 'package:flutter/material.dart';
import '../data/note_dao.dart';
import '../data/sqflite_database_helper.dart';
import '../models/note.dart';
import '../data/io_dao.dart';
import 'io_object_provider.dart';

class NoteProvider with ChangeNotifier implements IoObjectProvider<Note> {
  final SqfliteDatabaseHelper _databaseHelper;
  DateTime _selectedDate = DateTime.now();
  Note? _note;
  late IoDao<Note> _dao;

  NoteProvider(this._databaseHelper) {
    _dao = NoteDao(_databaseHelper, _selectedDate);
  }

  @override
  IoDao<Note> get dao => _dao;

  @override
  Future<Note?> get object async {
    _note ??= await _dao.read();
    return _note;
  }

  set selectedDate(DateTime date) {
    _selectedDate = date;
    _note = null;
    _dao = NoteDao(_databaseHelper, date);
    notifyListeners();
  }

  @override
  Future<void> addObject(Note object) async {
    await _dao.insert(object);
    _note = object;
    notifyListeners();
  }

  @override
  Future<void> updateObject(Note object) async {
    await _dao.update(object);
    _note = object;
    notifyListeners();
  }

  @override
  Future<void> deleteObject() async {
    await _dao.delete();
    _note = null;
    notifyListeners();
  }

  Future<void> saveNote(String content, String mood) async {
    final newNote = Note(
      content: content,
      mood: mood,
      date: _selectedDate,
    );
    
    if (_note == null) {
      await addObject(newNote);
    } else {
      await updateObject(newNote);
    }
  }
}