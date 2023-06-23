import 'package:flutter/widgets.dart';
import 'package:yandex_todo/features/task/task_model.dart';

class DataNotifier extends ChangeNotifier {
  ///Map <id: task> для того, чтобы обращаться к задаче за константное время
  late final Map<int, Task> _tasks;

  ///ревизия с сервера
  int? revision;

  Map<int, Task> getTasks([bool Function(Task t)? predicate]) =>
      Map.fromEntries(
          _tasks.entries.where((e) => (predicate?.call(e.value) ?? true)));

  void addTask(int id, Task t) {
    assert(!_tasks.containsKey(id));
    _tasks[id] = t;
    notifyListeners();
  }

  void editTask(int id, Task t) {
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
    final task = _tasks[id]!;
    _tasks[id] = task.copyWith(completed: !task.done);
    notifyListeners();
  }
}

class DataModel extends InheritedNotifier<DataNotifier> {
  const DataModel({super.key, super.notifier, required super.child});
  static DataNotifier? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataModel>()?.notifier;
  }
}
