import 'package:flutter/material.dart';

enum Importance {
  lowest('Нет'),
  low('Низкий'),
  high('!! Высокий');

  const Importance(this.text);

  final String text;
}

class TaskModel extends InheritedWidget {
  final Task task;
  const TaskModel({super.key, required this.task, required super.child});

  static TaskModel of(BuildContext context) {
    final t = context.dependOnInheritedWidgetOfExactType<TaskModel>();
    return t!;
  }

  @override
  bool updateShouldNotify(TaskModel oldWidget) => task != oldWidget.task;
}

class UpdateTaskNotification<T> extends Notification {
  final T _data;

  UpdateTaskNotification(this._data);
  get data => _data;
}

class Task {
  final DateTime? due;
  final Importance importance;
  final String text;
  final bool completed;
  final int? id;

  Task(
      {this.due,
      required this.importance,
      required this.text,
      required this.completed,
      this.id});
  Task.create()
      : this(completed: false, importance: Importance.lowest, text: '');

  Task copyWith(
      {DateTime? due, Importance? importance, String? text, bool? completed}) {
    return Task(
        importance: importance ?? this.importance,
        text: text ?? this.text,
        completed: completed ?? this.completed,
        due: due);
  }
}
