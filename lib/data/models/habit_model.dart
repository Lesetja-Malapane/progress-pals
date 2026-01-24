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

  // SOCIAL
  // Share with a friend (insert their email here)
  final String sharedWith;

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
      // Store DateTime as ISO string for SQLite
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'sharedWith': sharedWith,
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
        try {
          return String.fromCharCodes(value.cast<int>());
        } catch (e) {
          return '';
        }
      }
      return value.toString();
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
      sharedWith: toSafeString(map['sharedWith']),
      isSynced: (map['isSynced'] as int?) == 1,
    );
  }
}
