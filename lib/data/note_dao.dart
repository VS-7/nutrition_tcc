import 'package:sqflite/sqflite.dart';
import '../models/note.dart';
import 'io_dao.dart';
import 'sqflite_database_helper.dart';

class NoteDao implements IoDao<Note> {
  final SqfliteDatabaseHelper _databaseHelper;
  final DateTime _selectedDate;

  NoteDao(this._databaseHelper, this._selectedDate);

  String get _dateStr => _selectedDate.toIso8601String().split('T')[0];

  @override
  Future<Note?> read() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'date = ?',
      whereArgs: [_dateStr],
    );
    
    if (maps.isEmpty) return null;
    return Note.fromMap(maps.first);
  }

  @override
  Future<int> insert(Note item) async {
    final db = await _databaseHelper.database;
    return db.insert(
      'notes',
      {
        'content': item.content,
        'mood': item.mood,
        'date': _dateStr,
      },
    );
  }

  @override
  Future<int> update(Note item) async {
    final db = await _databaseHelper.database;
    return db.update(
      'notes',
      {
        'content': item.content,
        'mood': item.mood,
      },
      where: 'date = ?',
      whereArgs: [_dateStr],
    );
  }

  @override
  Future<int> delete() async {
    final db = await _databaseHelper.database;
    return db.delete(
      'notes',
      where: 'date = ?',
      whereArgs: [_dateStr],
    );
  }
}