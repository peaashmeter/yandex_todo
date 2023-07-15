import 'package:flutter/material.dart';
import 'package:yandex_todo/features/task/task_screen.dart';

import 'state.dart';
import 'widgets/scroll_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isCollapsed = false;
  bool showCompleted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const TaskScreen(),
          ));
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: NotificationListener(
          onNotification: (notification) => switch (notification) {
                CollapseNotification n => _onCollapseNotification(n),
                SwitchFilterNotification n => _onSwitchFilterNotification(n),
                _ => false
              },
          child: MainScreenModel(
              isCollapsed: isCollapsed,
              showCompleted: showCompleted,
              child: const MainScrollView())),
    );
  }

  bool _onCollapseNotification(CollapseNotification notification) {
    setState(() {
      isCollapsed = notification.isCollapsed;
    });
    return true;
  }

  bool _onSwitchFilterNotification(SwitchFilterNotification notification) {
    setState(() {
      showCompleted = notification.showCompleted;
    });
    return true;
  }
}
