import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:progress_pals/core/theme/app_colors.dart';
import 'package:progress_pals/presentation/pages/home/custom_navigation.dart';
import 'package:progress_pals/presentation/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static List<Widget> pages = [
    Center(
      child: FloatingActionButton(
        onPressed: () => Logger().i('add a habit'),
        tooltip: 'Add a habit',
        child: Row(children: [Text('Add a Habit'), const Icon(Icons.add)]),
      ),
    ),
    Center(child: Text("Manage Friends")),
    Center(child: Text('Analytics')),
    Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewmodel(),
      child: Consumer<HomeViewmodel>(
        builder: (context, homeViewModel, child) {
          return Scaffold(
            body: IndexedStack(
              index: homeViewModel.selectedIndex,
              children: pages,
            ),

            bottomNavigationBar: CustomNavigationBar(),
          );
        },
      ),
    );
  }
}
