import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<List<HabitModel>> getSharedHabits(
    String friendUserId,
    String currentUserEmail,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(friendUserId)
          .collection('habits')
          .where('sharedWith', isEqualTo: currentUserEmail)
          .get();
      return snapshot.docs
          .map((doc) => HabitModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      _logger.e('Error fetching shared habits: $e');
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
  // Future<void> addFriend(FriendModel friend) async {
  //   try {
  //     final habitRef = _firestore
  //         .collection('users')
  //         .doc(friend.userId)
  //         .collection('friends')
  //         .doc(friend.id);

  //     await habitRef.set(friend.toMap());
  //     _logger.i('Friend added to Firestore: ${friend.name}');
  //   } catch (e) {
  //     _logger.e('Error adding friend: $e');
  //     rethrow;
  //   }
  // }

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

  // Stream<List<FriendModel>> getFriends(String userId) {
  //   return _firestore
  //       .collection('friends')
  //       .where('userId', isEqualTo: userId)
  //       .snapshots()
  //       .map((snapshot) {
  //         return snapshot.docs
  //             .map((doc) => FriendModel.fromMap(doc.data()))
  //             .toList();
  //       });
  // }

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

  Future<List<HabitModel>> getSharedHabitsFromFriend(
    String friendUserId,
  ) async {
    try {
      // 1. Get the email DIRECTLY from the current auth session
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        _logger.e('Error: User not logged in or has no email');
        return [];
      }

      final myEmail = user.email!; // Use the exact email from Auth
      _logger.i(friendUserId);

      // 2. Run the query using that exact email
      final snapshot = await _firestore
          .collection('users')
          .doc(friendUserId)
          .collection('habits')
          .where('sharedWith', arrayContains: myEmail)
          .get();

      return snapshot.docs
          .map((doc) => HabitModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      // If this prints "permission-denied", double check the database console
      _logger.e('Error fetching shared habits: $e');
      return [];
    }
  }

  Future<void> debugFriendHabits(String friendUserId) async {
    final myEmail = FirebaseAuth.instance.currentUser?.email;

    _logger.i("--- STARTING DEBUG ---");
    _logger.i("1. Looking for Friend ID: $friendUserId");
    _logger.i(
      "2. My Email is: '$myEmail'",
    ); // Check for spaces or capitalization!

    _logger.t(friendUserId);

    try {
      // STEP 1: Fetch EVERYTHING in that friend's habit folder (No Filters)
      final allHabitsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendUserId)
          .collection('habits')
          .get();

      _logger.i(
        "3. Found ${allHabitsSnapshot.docs.length} total habits for this friend.",
      );

      if (allHabitsSnapshot.docs.isEmpty) {
        _logger.w(
          "!! PROBLEM: This friend has no habits at all in the database, or the friendID is wrong.",
        );
        return;
      }

      // STEP 2: Loop through them and inspect the 'sharedWith' field manually
      for (var doc in allHabitsSnapshot.docs) {
        final data = doc.data();
        final name = data['name'];
        final sharedWith = data['sharedWith'];

        _logger.i("   - Habit: '$name'");
        _logger.i("     Actual 'sharedWith' value in DB: $sharedWith");
        _logger.i("     Type of sharedWith: ${sharedWith.runtimeType}");

        // Check if our email is actually in there
        if (sharedWith is List && sharedWith.contains(myEmail)) {
          _logger.i("     [MATCH] This habit SHOULD show up!");
        } else {
          _logger.w(
            "     [NO MATCH] My email '$myEmail' is NOT in $sharedWith",
          );
        }
      }
    } catch (e) {
      _logger.e("CRITICAL ERROR: $e");
    }
    _logger.i("--- END DEBUG ---");
  }

  // 1. ADD FRIEND (Keep as is, this writes to the sub-collection)
Future<void> addFriendToUser(String currentUserId, FriendModel friend) async {
  // Save into: users -> ME -> friends -> NEW_FRIEND
  await _firestore
      .collection('users')
      .doc(currentUserId) 
      .collection('friends')
      .doc(friend.userId) // Using their ID as the doc ID prevents duplicates!
      .set(friend.toMap());
}

  // 2. GET FRIENDS (Fix this to match the Add function)
  Stream<List<FriendModel>> getFriends(String userId) {
    return _firestore
        .collection('users') // <--- Start at users
        .doc(userId) // <--- Go to YOUR document
        .collection('friends') // <--- Read from the SAME sub-collection
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => FriendModel.fromMap(doc.data()))
              .toList();
        });
  }

  // New helper to find a user's real ID based on their email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email) // Search by email
          .limit(1) // We only expect one user
          .get();

      if (snapshot.docs.isEmpty) {
        return null; // User not found
      }

      // Return the data AND the document ID (which is the real userId)
      final doc = snapshot.docs.first;
      final data = doc.data();
      data['userId'] = doc.id; // Ensure the ID is attached
      return data;
      
    } catch (e) {
      _logger.e('Error searching for user: $e');
      return null;
    }
  }
}
