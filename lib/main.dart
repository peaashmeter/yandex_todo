import 'package:flutter/material.dart';

import 'features/main/main_screen.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.blue,
          appBarTheme: const AppBarTheme(
              color: Color(0xFFF7F6F2),
              titleTextStyle: TextStyle(color: Colors.black),
              foregroundColor: Colors.black),
          textTheme: const TextTheme(
              labelLarge: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600))),
      home: const MainScreen(),
    );
  }
}
