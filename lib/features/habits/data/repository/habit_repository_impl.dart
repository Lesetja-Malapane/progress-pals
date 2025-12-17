// import '../../domain/entities/habit.dart';
// import '../../domain/repositories/habit_repository.dart';
// import '../models/habit_model.dart';

// class HabitRepositoryImpl implements HabitRepository {
//   @override
//   Future<List<Habit>> getHabits() async {
//     final response = await fetchFromFirebase();

//     return response.map<Habit>((json) {
//       return HabitModel.fromJson(json, json['id']);
//     }).toList();
//   }

//   @override
//   Future<void> createHabit(Habit habit) async {
//     final model = habit is HabitModel
//         ? habit
//         : HabitModel(id: habit.id, name: habit.name, description: habit.description, targetPerWeek: habit.targetPerWeek, completionDates: []
          
//         );

//     await saveToFirebase(model.toJson());
//   }
// }
