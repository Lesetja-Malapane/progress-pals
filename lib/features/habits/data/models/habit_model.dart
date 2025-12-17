import 'package:progress_pals/features/habits/domain/entities/habit.dart';

class HabitModel extends Habit {
  HabitModel({
    required super.id,
    required super.name,
    super.description,
    super.streak,
    required super.lastCompletionDate,
    required super.creationDate,
    super.isCompleted,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      streak: json['streak'],
      lastCompletionDate: DateTime.parse(json['lastCompletionDate']),
      creationDate: DateTime.parse(json['creationDate']),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'streak': streak,
      'lastCompletionDate': lastCompletionDate.toIso8601String(),
      'creationDate': creationDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

}