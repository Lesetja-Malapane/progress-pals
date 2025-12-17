import 'package:progress_pals/features/habits/domain/entities/habit.dart';

abstract class HabitRepository {
  Future<List<Habit>> getHabits();
  Future<void> createHabit(Habit habit);
}
