import 'package:progress_pals/features/habits/domain/entities/habit.dart';

class HabitModel extends Habit {
  HabitModel({
    required super.id,
    required super.name,
    super.description,
    super.targetPerWeek,
    required super.completionDates,
    super.isCompleted,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      targetPerWeek: json['targetPerWeek'],
      completionDates: List<DateTime>.from(
        json['completionDates'].map(
          (date) => DateTime.parse(date),
        ),
      ),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'targetPerWeek': targetPerWeek,
      'completionDates': completionDates.map((date) => date.toIso8601String()).toList(),
      'isCompleted': isCompleted,
    };
  }
}