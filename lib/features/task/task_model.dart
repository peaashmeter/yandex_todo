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
  final DateTime? deadline;
  final Importance importance;
  final String text;
  final bool done;
  final int? id;

  Task(
      {this.deadline,
      required this.importance,
      required this.text,
      required this.done,
      this.id});
  Task.create() : this(done: false, importance: Importance.lowest, text: '');

  Task.fromJson(json)
      : this(
            importance: Importance.values[json['importance']],
            text: json['text'],
            done: json['done'],
            deadline: json['deadline'],
            id: json['id']);

  Map<String, dynamic> toJson() {
    assert(id != null, 'У задачи должен быть id для публикации на сервер');
    return {
      'deadline': deadline?.millisecondsSinceEpoch,
      'importance': importance.index,
      'text': text,
      'done': done,
      'id': id!
    };
  }

  Task copyWith(
      {DateTime? due, Importance? importance, String? text, bool? completed}) {
    return Task(
        importance: importance ?? this.importance,
        text: text ?? this.text,
        done: completed ?? this.done,
        deadline: due);
  }
}
