import 'package:progress_pals/features/habits/domain/entities/habit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class AppDatabase {
  Future<Database> initDatabase();
  Future<void> closeDatabase();
  Future<void> clearDatabase();
  Future<List<Habit>> getHabits();
  Future<void> createHabit(Habit habit);
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
        [habit.id, habit.name, habit.description, habit.targetPerWeek, habit.completionDates.map((e) => e.toIso8601String()).join(',')],
      );
      print('inserted habit: $id');
    });
    return Future.value();
  }

  @override
  Future<List<Habit>> getHabits() {
    // TODO: implement getHabits
    throw UnimplementedError();
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
}
