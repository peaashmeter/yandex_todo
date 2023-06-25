import 'package:flutter/material.dart';
import 'dart:io';

enum Importance {
  low('Нет'),
  basic('Низкий'),
  important('!! Высокий');

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
  final String? id;

  Task(
      {this.deadline,
      required this.importance,
      required this.text,
      required this.done,
      this.id});
  Task.create() : this(done: false, importance: Importance.low, text: '');

  Task.fromJson(json)
      : this(
            importance: getImportance(json['importance']),
            text: json['text'],
            done: json['done'],
            deadline: json['deadline'],
            id: json['id']);

  Map<String, dynamic> toJson() {
    assert(id != null, 'У задачи должен быть id для публикации на сервер');
    return {
      'deadline': deadline?.millisecondsSinceEpoch,
      'importance': importance.name,
      'text': text,
      'done': done,
      'id': id!,
      'created_at': int.parse(id!),
      'changed_at': DateTime.timestamp().millisecondsSinceEpoch,
      'last_updated_by': _getDeviceId()
    };
  }

  Task copyWith(
      {DateTime? due,
      Importance? importance,
      String? text,
      bool? completed,
      String? id}) {
    return Task(
        id: id == null ? this.id : id,
        importance: importance ?? this.importance,
        text: text ?? this.text,
        done: completed ?? this.done,
        deadline: due == null ? this.deadline : due);
  }

  String _getDeviceId() {
    return Object.hashAll([
      Platform.localHostname,
      Platform.localeName,
      Platform.numberOfProcessors,
      Platform.operatingSystemVersion
    ]).toString();
  }

  static Importance getImportance(String text) => switch (text) {
        'low' => Importance.low,
        'basic' => Importance.basic,
        _ => Importance.important
      };
}
