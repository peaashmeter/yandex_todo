import 'package:flutter/material.dart';
import 'package:yandex_todo/core/data.dart';
import 'package:yandex_todo/core/navigator.dart';

import 'core/themes.dart';
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
    return BetterNavigator(
      child: FutureBuilder(
        future: model.init(network.listTasks, persistence.readTasks),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return DataModel(
            notifier: model,
            child: MaterialApp(
              darkTheme: darkTheme,
              theme: brightTheme,
              home: const MainScreen(),
            ),
          );
        },
      ),
    );
  }
}
