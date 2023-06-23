import 'package:flutter/material.dart';
import 'package:yandex_todo/core/data.dart';
import 'package:yandex_todo/features/task/task_model.dart';

import 'widgets/appbar.dart';
import 'widgets/sliver.dart';

class TaskScreen extends StatefulWidget {
  ///Если не null, то мы редактируем существующую задачу
  final int? id;
  const TaskScreen({super.key}) : id = null;
  const TaskScreen.edit(int this.id, {super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  Task task = Task.create();

  @override
  void didChangeDependencies() {
    if (widget.id != null) {
      final ref = DataModel.maybeOf(context)?.getTasks();
      if (ref == null) return;
      task = ref[widget.id]!;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UpdateTaskNotification>(
      onNotification: (notification) {
        setState(() => switch (notification.data) {
              DateTime? d => task = task.copyWith(due: d),
              Importance i => task = task.copyWith(importance: i),
              String t => task = task.copyWith(text: t),
              _ => null
            });
        return true;
      },
      child: TaskModel(
        task: task,
        child: const Scaffold(
          body: CustomScrollView(
            slivers: [TaskAppBar(), TaskEditSliver()],
          ),
        ),
      ),
    );
  }
}
