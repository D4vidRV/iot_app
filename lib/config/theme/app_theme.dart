import 'package:flutter/material.dart';

const seedColor = Color.fromARGB(255, 26, 74, 101);

class AppTheme {
  final bool isDarkMode;

  AppTheme({required this.isDarkMode});

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seedColor,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      );
}
