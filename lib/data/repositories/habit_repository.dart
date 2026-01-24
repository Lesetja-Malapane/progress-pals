import 'package:progress_pals/data/datasources/local/database_service.dart';
import 'package:progress_pals/data/models/habit_model.dart';

abstract class IHabitRepository {
  Future<List<HabitModel>> getHabits();
  Future<void> addHabit(HabitModel habit);
  Future<void> updateHabit(HabitModel habit);
  Future<void> deleteHabit(String id);
  Future<void> completeHabit(String id);
}

class HabitRepository implements IHabitRepository {
  final DatabaseService _databaseService;

  HabitRepository(this._databaseService);

  @override
  Future<List<HabitModel>> getHabits() async {
    return await _databaseService.getHabits();
  }

  @override
  Future<void> addHabit(HabitModel habit) async {
    await _databaseService.insertHabit(habit);
  }

  @override
  Future<void> updateHabit(HabitModel habit) async {
    await _databaseService.updateHabit(habit);
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _databaseService.deleteHabit(id);
  }

  @override
  Future<void> completeHabit(String id) async {
    final habits = await _databaseService.getHabits();
    final habit = habits.firstWhere((h) => h.id == id);

    final updatedHabit = HabitModel(
      id: habit.id,
      userId: habit.userId,
      name: habit.name,
      description: habit.description,
      repeatPerWeek: habit.repeatPerWeek,
      completedCount: habit.completedCount + 1,
      lastCompletedDate: DateTime.now(),
      sharedWith: habit.sharedWith,
      isSynced: false,
    );

    await _databaseService.updateHabit(updatedHabit);
  }
}
