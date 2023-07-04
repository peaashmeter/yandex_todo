import 'package:flutter/material.dart';
import 'package:yandex_todo/core/data.dart';

import 'features/main/main_screen.dart';
import 'core/persistence.dart' as persistence;
import 'core/network.dart' as network;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await persistence.init();
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final model = DataNotifier();
    return FutureBuilder(
      future: model.init(network.listTasks, persistence.readTasks),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return DataModel(
          notifier: model,
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
      },
    );
  }
}
