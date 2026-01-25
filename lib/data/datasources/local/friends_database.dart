import 'package:logger/web.dart';
import 'package:progress_pals/data/models/friend_model.dart';
import 'package:sqflite/sqflite.dart';

mixin FriendsDatabase {
  Future<void> initFriendsTable(Database db) async {
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

  Future<void> insertFriend(Database db, FriendModel friend) async {
    await db.insert(
      'Friends',
      friend.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    Logger().i('Friend added: ${friend.name}');
  }

  Future<List<FriendModel>> getFriends(Database db, String userId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'Friends',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return FriendModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteFriend(Database db, String friendId) async {
    await db.delete('Friends', where: 'id = ?', whereArgs: [friendId]);
    Logger().i('Friend removed');
  }
}
