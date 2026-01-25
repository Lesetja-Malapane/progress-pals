import 'dart:convert';

class HabitModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final int repeatPerWeek;
  final bool isSynced;

  // TRACKING
  final int completedCount;
  final DateTime? lastCompletedDate;
  final DateTime? lastResetDate;

  // SOCIAL
  // Share with a friend (insert their email here)
  final List<String> sharedWith;

  HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.repeatPerWeek,
    required this.completedCount,
    this.lastCompletedDate,
    this.lastResetDate,
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
      // Store DateTime as ISO string for SQLite
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'lastResetDate': lastResetDate?.toIso8601String(),
      'sharedWith': jsonEncode(sharedWith),
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    // Helper function to safely convert any value to String
    String toSafeString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is int) return value.toString();
      if (value is double) return value.toString();
      if (value is bool) return value.toString();
      // Handle binary data (Uint8List)
      if (value is List) {
        return value.map((e) => e.toString()).join(',');
      }
      return value.toString();
    }

    List<String> parseSharedWith(dynamic value) {
      if (value == null) return [];
      
      // If it's already a List (from Firestore), just return it
      if (value is List) return List<String>.from(value);
      
      // If it's a String (from SQLite), decode it
      if (value is String) {
        try {
          return List<String>.from(jsonDecode(value));
        } catch (e) {
          return [];
        }
      }
      
      return [];
    }

    // Parse lastCompletedDate safely
    DateTime? parsedDate;
    try {
      final dateStr = toSafeString(map['lastCompletedDate']);
      if (dateStr.isNotEmpty) {
        parsedDate = DateTime.tryParse(dateStr);
      }
    } catch (e) {
      parsedDate = null;
    }

    return HabitModel(
      id: toSafeString(map['id']),
      userId: toSafeString(map['userId']),
      name: toSafeString(map['name']),
      description: toSafeString(map['description']),
      repeatPerWeek: (map['repeatPerWeek'] as int?) ?? 0,
      completedCount: (map['completedCount'] as int?) ?? 0,
      lastCompletedDate: parsedDate,
      lastResetDate: map['lastResetDate'] != null
          ? DateTime.tryParse(toSafeString(map['lastResetDate']))
          : null,
      sharedWith: parseSharedWith(map['sharedWith']),
      isSynced: (map['isSynced'] as int?) == 1,
    );
  }
}
