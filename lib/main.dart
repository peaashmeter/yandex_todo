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
      theme: ThemeData.from(
          colorScheme: const ColorScheme.light(
            background: Color(0xFFF7F6F2),
            primary: Color(0xFFF7F6F2),
            onPrimary: Colors.black,
          ),
          textTheme: const TextTheme(
              labelLarge: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600))),
      home: const MainScreen(),
    );
  }
}
