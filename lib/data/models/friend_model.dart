class FriendModel {
  final String id;
  final String userId;
  final String email;
  final String name;
  final DateTime? addedDate;

  FriendModel({
    required this.id,
    required this.userId,
    required this.email,
    required this.name,
    this.addedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'email': email,
      'name': name,
      'addedDate': addedDate?.toIso8601String(),
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    String toSafeString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      return value.toString();
    }

    return FriendModel(
      id: toSafeString(map['id']),
      userId: toSafeString(map['userId']),
      email: toSafeString(map['email']),
      name: toSafeString(map['name']),
      addedDate: map['addedDate'] != null
          ? DateTime.tryParse(toSafeString(map['addedDate']))
          : null,
    );
  }
}
