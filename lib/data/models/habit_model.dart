import 'package:flutter/foundation.dart';

class HabitModel {
  final String id;
  final String name;
  final String description;
  final int repeatPerWeek;
  final Map<String, dynamic> shareWith;

  HabitModel({
    required this.id,
    required this.name,
    required this.description,
    required this.repeatPerWeek,
    required this.shareWith,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'repeatPerWeek': repeatPerWeek,
      'shareWith': shareWith,
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      repeatPerWeek: map['repeatPerWeek'],
      shareWith: Map<String, dynamic>.from(map['shareWith']),
    );
  }
}
