import 'package:progress_pals/data/models/habit_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class AppDatabase {
  Future<Database> initDatabase();
  Future<void> closeDatabase();
}

class DatabaseService implements AppDatabase {
  static late Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  @override
  Future<Database> initDatabase() async {
    var database = await openDatabase(
      "habits.db",
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE IF NOT EXISTS Habits (
              id TEXT PRIMARY KEY, 
              name TEXT, 
              description TEXT, 
              repeatPerWeek INTEGER, 
              completedCount INTEGER, 
              lastCompletedDate TEXT, 
              sharedWith TEXT,
              isSynced INTEGER
            )
          ''');
      },
    );
    return Future.value(database);
  }

  @override
  Future<void> closeDatabase() async {
    await _database?.delete('Habits');
    return Future.value();
  }

  Future<void> insertHabit(HabitModel habit) async {
    final db = await database;
    await db.insert(
      'Habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<HabitModel>> getHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Habits');
    return List.generate(maps.length, (i) {
      return HabitModel.fromMap(maps[i]);
    });
  }

  Future<void> updateHabit(HabitModel habit) async {
    final db = await database;
    await db.update(
      'Habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<void> deleteHabit(String id) async {
    final db = await database;
    await db.delete('Habits', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markHabitAsSynced(String id) async {
    final db = await database;
    await db.update(
      'Habits',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
