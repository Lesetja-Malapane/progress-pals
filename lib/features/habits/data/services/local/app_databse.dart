import 'package:progress_pals/features/habits/domain/entities/habit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

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
    // TODO: implement createHabit
    // throw UnimplementedError();

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
      print('inserted habit: $id');
    });
    return Future.value();
  }

  @override
  Future<List<Habit>> getHabits() {
    // TODO: implement getHabits
    // throw UnimplementedError();
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
    return _database!.transaction((txn) async {
      Future<int> Function(String sql, [List<Object?>? arguments]) id =  txn.rawUpdate;
    });
  }

  @override
  initDatabase() {
    var database = openDatabase(
      'habits.db',
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE IF NOT EXIST habits (id INTEGER PRIMARY KEY, name TEXT, description TEXT, targetPerWeek INTEGER, completedDates TEXT)',
        );
      },
    );
    return Future.value(database);
  }
  
  @override
  Future<void> deleteHabit(String id) {
    // TODO: implement deleteHabit
    // throw UnimplementedError();
    return _database!.transaction((txn) async {
      await txn.rawDelete('DELETE FROM habits WHERE id = ?', [id]);
    });
  }
}
