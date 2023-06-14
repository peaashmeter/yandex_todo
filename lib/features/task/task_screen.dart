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
  DateTime? due;
  Importance importance = Importance.lowest;
  String text = '';

  @override
  void didChangeDependencies() {
    if (widget.id != null) {
      final ref = DataModel.maybeOf(context)?.getTasks()[widget.id];
      if (ref == null) return;

      due = ref.due;
      importance = ref.importance;
      text = ref.text;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UpdateTaskNotification>(
      onNotification: (notification) {
        setState(() => switch (notification.data) {
              DateTime? d => due = d,
              Importance i => importance = i,
              String t => text = t,
              _ => null
            });
        return true;
      },
      child: TaskModel(
        due: due,
        importance: importance,
        text: text,
        id: widget.id,
        child: const Scaffold(
          body: CustomScrollView(
            slivers: [TaskAppBar(), TaskEditSliver()],
          ),
        ),
      ),
    );
  }
}
