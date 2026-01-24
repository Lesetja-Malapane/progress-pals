import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  int _currentDayIndex = 0;
  final List<String> _weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  List<String> get weekDays => _weekDays;
  int get currentDayIndex => _currentDayIndex;

  HomeViewModel() {
    _init();
  }

    Future<void> _init() async {
    _setupDate();
  }

  void _setupDate() {
    _currentDayIndex = DateTime.now().weekday - 1;
    notifyListeners();
  }

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
