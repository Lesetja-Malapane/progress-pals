import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:progress_pals/core/theme/app_theme.dart';
import 'package:progress_pals/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:progress_pals/app_router.dart';
import 'package:progress_pals/data/datasources/local/database_service.dart';
import 'package:progress_pals/data/repositories/habit_repository.dart';
import 'package:progress_pals/presentation/viewmodels/home_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => DatabaseService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ProxyProvider<DatabaseService, HabitRepository>(
          create: (context) => HabitRepository(context.read<DatabaseService>()),
          update: (context, databaseService, previous) =>
              HabitRepository(databaseService),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(context.read<HabitRepository>()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Progress Pals',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
