# progress_pals

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

mvvm & clean architecture
lib/
├── core/                   # App-wide constants, themes, and generic utilities
│   ├── error/              # Failure classes (ServerFailure, CacheFailure)
│   ├── theme/              # AppTheme, Colors
│   └── usecases/           # Base UseCase interface
├── data/                   # The Data Layer
│   ├── datasources/        # Local (SQLite/Hive) and Remote (Firebase/API)
│   ├── models/             # Data Models (JSON serialization/DTOs)
│   └── repositories/       # HabitRepositoryImpl (implements domain repo)
├── domain/                 # The Domain Layer (Pure Dart)
│   ├── entities/           # Habit, CompletionLog (Business Objects)
│   ├── repositories/       # HabitRepository (Abstract Interface)
│   └── usecases/           # AddHabit, GetHabits, MarkComplete
├── presentation/           # The UI Layer (MVVM / State Management)
│   ├── pages/              # HabitHomeScreen, HabitSettingsPage
│   ├── viewmodels/         # ChangeNotifier / BLoC / StateNotifier
│   └── widgets/            # HabitTile, StreakChart, CustomButton
└── main.dart

-> Rive for custom navbar

26/01/26 Break day