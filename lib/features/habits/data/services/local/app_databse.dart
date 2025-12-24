import 'package:logger/web.dart';
import 'package:progress_pals/features/habits/domain/entities/habit.dart';
import 'package:sqflite/sqflite.dart';

var logger = Logger();

abstract class AppDatabase {
  Future<Database> initDatabase();
  Future<void> closeDatabase();
  Future<void> clearDatabase();
  Future<List<Habit>> getHabits();
  Future<void> createHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(String id);
}

class DatabaseService implements AppDatabase {
  static late Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  @override
  Future<void> clearDatabase() {
    return _database!.delete('habits');
  }

  @override
  Future<void> closeDatabase() {
    // TODO: implement closeDatabase
    throw UnimplementedError();
  }

  @override
  Future<void> createHabit(Habit habit) async {
    await _database?.transaction((txn) async {
      int id = await txn.rawInsert(
        'INSERT INTO habits(id, name, description, targetPerWeek, completedDates) VALUES(?, ?, ?, ?, ?)',
        [
          habit.id,
          habit.name,
          habit.description,
          habit.targetPerWeek,
          habit.completionDates.map((e) => e.toIso8601String()).join(','),
        ],
      );
      logger.d('inserted habit: $id');
    });
    return Future.value();
  }

  @override
  Future<List<Habit>> getHabits() {
    return _database!.transaction((txn) async {
      final List<Map<String, dynamic>> maps = await txn.query('habits');
      return List.generate(maps.length, (i) {
        return Habit(
          id: maps[i]['id'],
          name: maps[i]['name'],
          description: maps[i]['description'],
          targetPerWeek: maps[i]['targetPerWeek'],
          completionDates: maps[i]['completedDates']
              .split(',')
              .map((e) => DateTime.parse(e))
              .toList(),
        );
      });
    });
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _database?.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE habits SET name = ?, description = ?, targetPerWeek = ?, completedDates = ? WHERE id = ?',
        [
          habit.name,
          habit.description,
          habit.targetPerWeek,
          habit.completionDates.map((e) => e.toIso8601String()).join(','),
          habit.id,
        ],
      );
    });
  }

  @override
  initDatabase() {
    var database = openDatabase(
      'habits.db',
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE IF NOT EXISTS habits (id INTEGER PRIMARY KEY, name TEXT, description TEXT, targetPerWeek INTEGER, completedDates TEXT)',
        );
      },
    );
    return Future.value(database);
  }
  
  @override
  Future<void> deleteHabit(String id) {
    return _database!.transaction((txn) async {
      await txn.rawDelete('DELETE FROM habits WHERE id = ?', [id]);
    });
  }
}
