import 'package:flutter/widgets.dart';
import 'package:yandex_todo/features/task/task_model.dart';
import 'network.dart' as net;

class DataNotifier extends ChangeNotifier {
  ///Map <id: task> для того, чтобы обращаться к задаче за константное время
  Map<String, Task> _tasks = {};

  ///ревизия с сервера
  int? revision;

  Map<String, Task> getTasks([bool Function(Task t)? predicate]) =>
      Map.fromEntries(
          _tasks.entries.where((e) => (predicate?.call(e.value) ?? true)));

  Future<int> init() async {
    final data = await net.listTasks();
    final (rev, tasks) = data;
    _tasks = Map.fromIterable(tasks, key: (t) => t.id, value: (t) => t);
    return rev;
  }

  void addTask(String id, Task t) async {
    assert(!_tasks.containsKey(id));
    _tasks[id] = t;
    assert(revision != null);
    revision = await net.addTask(t, revision!);
    notifyListeners();
  }

  void editTask(String id, Task t) async {
    assert(_tasks.containsKey(id));
    _tasks[id] = t;
    assert(revision != null);
    revision = await net.updateTask(t, revision!);
    notifyListeners();
  }

  void removeTask(String id) async {
    assert(_tasks.containsKey(id));
    _tasks.remove(id);
    assert(revision != null);
    revision = await net.deleteTask(id, revision!);
    notifyListeners();
  }

  void completeTask(String id) async {
    assert(_tasks.containsKey(id));
    final task = _tasks[id]!;
    _tasks[id] = task.copyWith(completed: !task.done);
    assert(revision != null);
    revision = await net.updateTask(_tasks[id]!, revision!);
    notifyListeners();
  }
}

class DataModel extends InheritedNotifier<DataNotifier> {
  const DataModel({super.key, super.notifier, required super.child});
  static DataNotifier? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataModel>()?.notifier;
  }
}
