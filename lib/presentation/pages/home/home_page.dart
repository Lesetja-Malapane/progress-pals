import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:progress_pals/presentation/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final List<Widget> _pages = [
    SafeArea(
      child: Center(
        child: FloatingActionButton(
          onPressed: () => Logger().i('add a habit'),
          tooltip: 'Add a habit',
          child: const Icon(Icons.add),
        ),
      ),
    ),
    const Center(child: Text("Manage Friends")),
    const Center(child: Text('Analytics')),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewmodel>(context);
    return Scaffold(
      body: _pages[homeViewModel.selectedIndex],
      extendBody: true,
      bottomNavigationBar: DotNavigationBar(
        itemPadding: const EdgeInsets.only(
          left: 30,
          right: 30,
          top: 16,
          bottom: 16,
        ),
        margin: const EdgeInsets.all(0),
        marginR: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
        ),
        paddingR: const EdgeInsets.all(0),
        currentIndex: homeViewModel.selectedIndex,
        onTap: homeViewModel.setIndex,
        items: [
          DotNavigationBarItem(
            icon: Icon(Icons.home),
            selectedColor: Colors.purple,
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.people),
            selectedColor: Colors.pink,
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            selectedColor: Colors.orange,
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.person),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
