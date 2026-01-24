import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  final String userId; // CHANGED: Needed for security & queries
  final String name;
  final String description;
  final int repeatPerWeek; // e.g., 3 means "3 times a week"
  final bool isSynced;

  // TRACKING
  final int completedCount;
  final DateTime? lastCompletedDate; // Used to check if we need to reset

  // SOCIAL
  // A list of friend UIDs is usually easier to manage than a Map for beginners
  final List<String> sharedWith;

  HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.repeatPerWeek,
    required this.completedCount,
    this.lastCompletedDate,
    required this.sharedWith,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'repeatPerWeek': repeatPerWeek,
      'completedCount': completedCount,
      // Store DateTime as a Firestore Timestamp
      'lastCompletedDate': lastCompletedDate != null
          ? Timestamp.fromDate(lastCompletedDate!)
          : null,
      'sharedWith': sharedWith,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      repeatPerWeek: map['repeatPerWeek'] ?? 0,
      completedCount: map['completedCount'] ?? 0,
      // Convert Firestore Timestamp back to DateTime
      lastCompletedDate: map['lastCompletedDate'] != null
          ? (map['lastCompletedDate'] as Timestamp).toDate()
          : null,
      sharedWith: List<String>.from(map['sharedWith'] ?? []),
      isSynced: map['isSynced'] == 1,
    );
  }
}
