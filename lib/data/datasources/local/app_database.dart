import 'package:sqflite/sqflite.dart';

abstract class AppDatabase {
  Future<Database> initDatabase();
  Future<void> closeDatabase();
}

class DatabaseService implements AppDatabase {
  static late Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  @override
  Future<Database> initDatabase() async {
    var database = await openDatabase(
      "habits.db",
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE Habits (id INTEGER PRIMARY KEY, title TEXT, description TEXT, status TEXT)',
        );
      },
    );
    return Future.value(database);
  }

  @override
  Future<void> closeDatabase() async {
    await _database?.delete('Habits');
    return Future.value();
  }
}
