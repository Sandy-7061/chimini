
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggletheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark; // Properly update the state.
    } else {
      state = ThemeMode.light; // Properly update the state.
    }
  }


}
  final themeProvider = StateNotifierProvider<ThemeNotifier,ThemeMode>((ref){
    return ThemeNotifier();
});
