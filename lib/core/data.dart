import 'package:flutter/widgets.dart';
import 'package:yandex_todo/features/task/task_model.dart';

class DataNotifier extends ChangeNotifier {
  ///Map <id: task> для того, чтобы обращаться к задаче за константное время
  late final Map<int, TaskModel> _tasks;

  DataNotifier() {
    ///тестовые данные
    _tasks = {};
    for (var i = 0; i < 5; i++) {
      _tasks.addAll({
        i: TaskModel(
            id: i,
            due: DateTime(2024),
            importance: Importance.low,
            text: 'Сделать что-то $i',
            child: const Placeholder())
      });
    }
  }

  Map<int, TaskModel> getTasks([bool Function(TaskModel t)? predicate]) =>
      Map.fromEntries(
          _tasks.entries.where((e) => (predicate?.call(e.value) ?? true)));

  void addTask(int id, TaskModel t) {
    assert(!_tasks.containsKey(id));
    _tasks[id] = t;
    notifyListeners();
  }

  void editTask(int id, TaskModel t) {
    assert(_tasks.containsKey(id));
    _tasks[id] = t;
    notifyListeners();
  }

  void removeTask(int id) {
    assert(_tasks.containsKey(id));
    _tasks.remove(id);
    notifyListeners();
  }

  void completeTask(int id) {
    assert(_tasks.containsKey(id));
    _tasks[id] = _tasks[id]!.switchStatus();
    notifyListeners();
  }
}

class DataModel extends InheritedNotifier<DataNotifier> {
  const DataModel({super.key, super.notifier, required super.child});
  static DataNotifier? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataModel>()?.notifier;
  }
}
