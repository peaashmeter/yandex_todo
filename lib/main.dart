import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yandex_todo/core/data.dart';

import 'features/main/main_screen.dart';

void main() {
  if (kDebugMode) {
    FlutterError.onError = (details) =>
        log(details.exceptionAsString(), stackTrace: details.stack);
    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    };
  }

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DataModel(
      notifier: DataNotifier(),
      child: MaterialApp(
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
      ),
    );
  }
}
