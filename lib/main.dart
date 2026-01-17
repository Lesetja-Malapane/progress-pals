import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:progress_pals/firebase_options.dart';
import 'package:progress_pals/presentation/pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      title: 'Progress Pals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/': (context) => const WelcomePage(),
        '/sign-in': (context) => const Placeholder(),
        '/sign-up': (context) => const Placeholder(),
        '/forgot-password': (context) => const Placeholder(),
        '/home': (context) => const Placeholder(),
        '/friend-list': (context) => const Placeholder(),
        '/add-friend': (context) => const Placeholder(),
        '/analytics': (context) => const Placeholder(),
        '/profile': (context) => const Placeholder(),
      },
    );
  }
}