import 'package:flutter/material.dart';
import 'package:progress_pals/core/theme/app_colors.dart';
import 'package:progress_pals/presentation/pages/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Widget> pages = [
    Center(child: Text('Home')),
    Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewmodel(),
      child: Consumer<HomeViewmodel>(
        builder: (context, homeViewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.white,

            body: IndexedStack(
              index: homeViewModel.selectedIndex,
              children: pages,
            ),

            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (value) => homeViewModel.setIndex(value),
              selectedIndex: homeViewModel.selectedIndex,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: "home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
