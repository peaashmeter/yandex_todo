import 'package:flutter_test/flutter_test.dart';
import 'package:yandex_todo/core/network.dart';
import 'package:yandex_todo/features/task/task_model.dart';

main() {
  group('Тест взаимодействия с сервером', () {
    // listTasks
    test('listTasks should retrieve the list of tasks and the revision',
        () async {
      var res = await listTasks();
      expect(res, isNotNull);
      expect(res?.$1.runtimeType, int);
      expect(res?.$2.runtimeType, List<Task>);
    });

// updateTasks
    test('updateTasks should update the list of tasks and the revision',
        () async {
      var res = await listTasks();
      expect(res, isNotNull);
      var list = res!.$2; //getting the list of tasks
      var revised = res.$1 + 1; //incrementing the revision
      res = await updateTasks(list, revised);
      expect(res?.$1, revised); //checking if the revision was incremented
    });

// addTask
    test('addTask should add a single task with a given revision', () async {
      Task t =
          Task(importance: Importance.low, text: 'test', done: false, id: '42');
      var res = await listTasks();
      var listCount = res!.$2.length;
      var rev = res.$1;
      await addTask(t, rev);
      var newList = await listTasks();
      expect(newList?.$2.length, listCount + 1);
    });

// getTaskbyId
    test('getTaskbyId should retrieve a single task and its revision',
        () async {
      var res = await getTaskById('42');
      expect(res, isNotNull);
      expect(res?.$1, isNotNull);
      expect(res?.$2, isNotNull);
    });

// updateTask
    test('updateTask should update a single task with a given revision',
        () async {
      Task t =
          Task(importance: Importance.low, text: 'test', done: true, id: '42');
      await updateTask(t, 1);
      var newTask = await getTaskById('42');
      expect(newTask?.$2.text, 'test');
    });

// deleteTask
    test('deleteTask should delete a single task with a given revision',
        () async {
      var res = await listTasks();
      var listCount = res!.$2.length;
      var revised = res.$1;
      await deleteTask('42', revised);
      var newList = await listTasks();
      expect(newList?.$2.length, listCount - 1);
    });
  });
}
