class Habit {
  final String id;
  final String name;
  final String description;
  final int targetPerWeek;
  final List<DateTime> completionDates;
  bool isCompleted = false;

  Habit({
    required this.id,
    required this.name,
    this.description = '',
    this.targetPerWeek = 0,
    required this.completionDates,
    this.isCompleted = false,
  });
}
