import 'package:flutter/material.dart';
import 'package:yandex_todo/features/task/task_screen.dart';

///Я не знаю, зачем я это сделал.
class BetterNavigator extends InheritedWidget {
  late final BuildContext context;
  final Widget child;

  BetterNavigator({required this.child}) : super(child: child);

  void setContext(BuildContext _context) {
    context = _context;
  }

  void back() {
    Navigator.of(context).pop();
  }

  void toExistingTask(String id) async {
    final route = MaterialPageRoute(
      builder: (context) => TaskScreen.edit(id),
    );
    await Navigator.of(context).push(route);
  }

  void toNewTask() async {
    final route = MaterialPageRoute(
      builder: (context) => const TaskScreen(),
    );
    await Navigator.of(context).push(route);
  }

  @override
  bool updateShouldNotify(BetterNavigator oldWidget) =>
      context != oldWidget.context;

  static BetterNavigator of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<BetterNavigator>()!;
}
