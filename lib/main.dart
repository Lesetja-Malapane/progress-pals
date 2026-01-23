import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:progress_pals/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:progress_pals/app_router.dart';
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
      providers: [ChangeNotifierProvider(create: (_) => HomeViewModel())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Progress Pals',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.primarySoft,
            surface: AppColors.surface,
            error: AppColors.error,
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(color: AppColors.textPrimary),
            bodyMedium: TextStyle(color: AppColors.textSecondary),
            bodySmall: TextStyle(color: AppColors.textDisabled),
          ),
          dividerColor: AppColors.divider,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
