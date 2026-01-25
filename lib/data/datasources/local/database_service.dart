import 'package:logger/web.dart';
import 'package:progress_pals/data/models/friend_model.dart';
import 'package:progress_pals/data/models/habit_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class AppDatabase {
  Future<Database> initDatabase();
  Future<void> closeDatabase();
}

class DatabaseService implements AppDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  @override
  Future<Database> initDatabase() async {
    _database = await openDatabase(
      "habits.db",
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE IF NOT EXISTS Habits (
              id TEXT PRIMARY KEY, 
              userId TEXT,
              name TEXT, 
              description TEXT, 
              repeatPerWeek INTEGER, 
              completedCount INTEGER, 
              lastCompletedDate TEXT, 
              lastResetDate TEXT,
              sharedWith TEXT,
              isSynced INTEGER
            )
          ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS Friends (
            id TEXT PRIMARY KEY,
            userId TEXT,
            email TEXT,
            name TEXT,
            addedDate TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE Habits ADD COLUMN userId TEXT');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE Habits ADD COLUMN lastResetDate TEXT');
        }
        if (oldVersion < 4) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS Friends (
              id TEXT PRIMARY KEY,
              userId TEXT,
              email TEXT,
              name TEXT,
              addedDate TEXT
            )
          ''');
        }
      },
    );
    return _database!;
  }

  @override
  Future<void> closeDatabase() async {
    await _database?.close();
    _database = null;
  }

  Future<void> insertHabit(HabitModel habit) async {
    final db = await database;
    await db.insert(
      'Habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    Logger().i('Habit inserted: $habit');
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

  // Friend management methods
  Future<void> insertFriend(FriendModel friend) async {
    final db = await database;
    await db.insert(
      'Friends',
      friend.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    Logger().i('Friend added: ${friend.name}');
  }

  Future<List<FriendModel>> getFriends(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Friends',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return FriendModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteFriend(String friendId) async {
    final db = await database;
    await db.delete('Friends', where: 'id = ?', whereArgs: [friendId]);
    Logger().i('Friend removed');
  }

  Future<void> updateFriend(FriendModel updatedFriend) async {
    final db = await database;
    await db.update(
      'Friends',
      updatedFriend.toMap(),
      where: 'id = ?',
      whereArgs: [updatedFriend.id],
    );
  }
}
