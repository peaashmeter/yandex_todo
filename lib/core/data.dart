import 'package:flutter/widgets.dart';
import 'package:yandex_todo/features/task/task_model.dart';

class DataNotifier extends ChangeNotifier {
  ///Map id: task для того, чтобы обращаться к задаче за константное время
  final Map<int, TaskModel> _tasks = {};
  Map<int, TaskModel> get tasks => _tasks;

  void addTask(TaskModel t) {
    final id = DateTime.timestamp().millisecondsSinceEpoch;
    _tasks[id] = t;
    notifyListeners();
  }

  void removeTask(int id) {
    _tasks.remove(id);
    notifyListeners();
  }
}

class DataModel extends InheritedNotifier<DataNotifier> {
  const DataModel({super.key, super.notifier, required super.child});
  static DataNotifier? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataModel>()?.notifier;
  }
}
