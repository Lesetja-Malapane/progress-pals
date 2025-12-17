class Habit {
  final String id;
  final String name;
  final String description;
  final int streak;
  final DateTime lastCompletionDate;
  final DateTime creationDate;
  bool isCompleted = false;

  Habit({
    required this.id,
    required this.name,
    this.description = '',
    this.streak = 0,
    required this.lastCompletionDate,
    required this.creationDate,
    this.isCompleted = false,
  });
}
