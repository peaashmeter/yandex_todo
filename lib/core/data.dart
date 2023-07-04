import 'package:flutter/widgets.dart';
import 'package:yandex_todo/features/task/task_model.dart';
import 'network.dart' as net;
import 'persistence.dart' as local;

class DataNotifier extends ChangeNotifier {
  ///Map <id: task> для того, чтобы обращаться к задаче за константное время
  Map<String, Task> _tasks = {};

  ///ревизия с сервера
  int? revision;

  Map<String, Task> getTasks([bool Function(Task t)? predicate]) =>
      Map.fromEntries(
          _tasks.entries.where((e) => (predicate?.call(e.value) ?? true)));

  Future<int> init(Future<(int, List<Task>)?> Function() getRemoteTasks,
      Future<(int, List<Task>)?> Function() getLocalTasks) async {
    final remoteData = await getRemoteTasks();
    final localData = await getLocalTasks();

    if (localData != null) {
      final localRev = localData.$1;
      final localTasks = localData.$2;

      if (remoteData != null) {
        final remoteRev = remoteData.$1;
        if (localRev >= remoteRev) {
          await net.updateTasks(localTasks, localRev);
        } else {
          await local.updateTasks(remoteData.$2, remoteData.$1);
        }
      }
      _tasks = Map.fromIterable(localTasks, key: (t) => t.id, value: (t) => t);

      revision = localRev;
      return localRev;
    } else if (remoteData != null) {
      final (rev, tasks) = remoteData;
      local.updateTasks(tasks, rev);

      _tasks = Map.fromIterable(tasks, key: (t) => t.id, value: (t) => t);

      revision = rev;
      return rev;
    }

    throw (DataAccessError());
  }

  void addTask(String id, Task t) async {
    assert(!_tasks.containsKey(id));
    _tasks[id] = t;
    assert(revision != null);
    revision = revision! + 1;
    await local.updateTasks(_tasks.values, revision!);
    await net.addTask(t, revision!);
    notifyListeners();
  }

  void editTask(String id, Task t) async {
    assert(_tasks.containsKey(id));
    _tasks[id] = t;
    assert(revision != null);
    revision = revision! + 1;
    await local.updateTasks(_tasks.values, revision!);
    await net.updateTask(t, revision!);
    notifyListeners();
  }

  void removeTask(String id) async {
    assert(_tasks.containsKey(id));
    _tasks.remove(id);
    assert(revision != null);
    revision = revision! + 1;
    await local.updateTasks(_tasks.values, revision!);
    await net.deleteTask(id, revision!);
    notifyListeners();
  }

  void completeTask(String id) async {
    assert(_tasks.containsKey(id));
    final task = _tasks[id]!;
    _tasks[id] = task.copyWith(completed: !task.done);
    assert(revision != null);
    revision = revision! + 1;
    await local.updateTasks(_tasks.values, revision!);
    await net.updateTask(_tasks[id]!, revision!);
    notifyListeners();
  }
}

class DataModel extends InheritedNotifier<DataNotifier> {
  const DataModel({super.key, super.notifier, required super.child});
  static DataNotifier? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataModel>()?.notifier;
  }
}

///Критическая ошибка, возникающая в том случае, если не удалось прочитать
///ни локальные, ни облачные данные
class DataAccessError extends Error {}
