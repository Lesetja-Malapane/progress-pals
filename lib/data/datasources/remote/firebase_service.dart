import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:progress_pals/data/models/friend_model.dart';
import 'package:progress_pals/data/models/habit_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  // Habits
  Future<void> addHabit(HabitModel habit) async {
    try {
      final habitRef = _firestore
          .collection('users')
          .doc(habit.userId)
          .collection('habits')
          .doc(habit.id);

      await habitRef.set(habit.toMap());
      _logger.i('Habit added to Firestore: ${habit.name}');
    } catch (e) {
      _logger.e('Error adding habit: $e');
      rethrow;
    }
  }

  Stream<List<HabitModel>> getHabits(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return HabitModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<List<HabitModel>> getHabitsOnce(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .get();
      return snapshot.docs
          .map((doc) => HabitModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      _logger.e('Error fetching habits: $e');
      return [];
    }
  }

  Future<void> updateHabit(HabitModel habit) async {
    try {
      await _firestore
          .collection('users')
          .doc(habit.userId)
          .collection('habits')
          .doc(habit.id)
          .update(habit.toMap());
      _logger.i('Habit updated in Firestore: ${habit.name}');
    } catch (e) {
      _logger.e('Error updating habit: $e');
      rethrow;
    }
  }

  Future<void> deleteHabit(String habitId, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(habitId)
          .delete();
      _logger.i('Habit deleted from Firestore');
    } catch (e) {
      _logger.e('Error deleting habit: $e');
      rethrow;
    }
  }

  // Friends
  Future<void> addFriend(FriendModel friend) async {
    try {
      await _firestore.collection('friends').doc(friend.id).set(friend.toMap());
      _logger.i('Friend added to Firestore: ${friend.name}');
    } catch (e) {
      _logger.e('Error adding friend: $e');
      rethrow;
    }
  }

  Future<List<FriendModel>> getFriendsOnce(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('friends')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) => FriendModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      _logger.e('Error fetching friends: $e');
      return [];
    }
  }

  Stream<List<FriendModel>> getFriends(String userId) {
    return _firestore
        .collection('friends')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => FriendModel.fromMap(doc.data()))
              .toList();
        });
  }

  Future<void> updateFriend(FriendModel friend) async {
    try {
      await _firestore
          .collection('friends')
          .doc(friend.id)
          .update(friend.toMap());
      _logger.i('Friend updated in Firestore: ${friend.name}');
    } catch (e) {
      _logger.e('Error updating friend: $e');
      rethrow;
    }
  }

  Future<void> removeFriend(String friendId) async {
    try {
      await _firestore.collection('friends').doc(friendId).delete();
      _logger.i('Friend deleted from Firestore');
    } catch (e) {
      _logger.e('Error removing friend: $e');
      rethrow;
    }
  }
}
