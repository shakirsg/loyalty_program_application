import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _selectedIndex = 0;
  bool isRereshing = false;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
void setIndex_(int index) {
    _selectedIndex = index;
    // notifyListeners();
  }
  // void refresh(int index) {
  //   // _selectedIndex = index;
  //   isRereshing = true;
  //   notifyListeners();
  //   isRereshing = false;

  // }
}
