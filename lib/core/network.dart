///Работа с бэкендом здесь
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:yandex_todo/features/task/task_model.dart';

const baseurl = 'https://beta.mrdekk.ru/todobackend';

///TODO: скрыть токен
const token = 'Jurev_I';

Future<List<Task>> listTasks() async {
  final client = HttpClient();
  try {
    final request = await client.get(baseurl, 443, '/list');
    request.headers.add('Authorization', 'Bearer $token');
    final response = await request.close();

    final data = await response.transform(utf8.decoder).join();
    final json = jsonDecode(data) as List<Map>;
    return json.map((e) => Task.fromJson(e)).toList();
  } finally {
    client.close();
  }
}

Future<Task> getTaskbyId(int id) async {
  final client = HttpClient();
  try {
    final request = await client.get(baseurl, 443, '/list/$id');
    request.headers.add('Authorization', 'Bearer $token');
    final response = await request.close();

    final data = await response.transform(utf8.decoder).join();
    final json = jsonDecode(data) as Map;
    return Task.fromJson(json);
  } finally {
    client.close();
  }
}

Future addTask(Task task, int revision) async {
  final client = HttpClient();
  try {
    final request = await client.post(baseurl, 443, '/list/');
    request.headers
      ..add('Authorization', 'Bearer $token')
      ..add('X-Last-Known-Revision', revision);
    request.write(task);
    await request.close();
  } finally {
    client.close();
  }
}

Future updateTask(Task task, int revision) async {
  final client = HttpClient();
  try {
    final request = await client.put(baseurl, 443, '/list/');
    request.headers
      ..add('Authorization', 'Bearer $token')
      ..add('X-Last-Known-Revision', revision);
    request.write(task);
    await request.close();
  } finally {
    client.close();
  }
}

Future deleteTask() async {
  final client = HttpClient();
  try {
    final request = await client.delete(baseurl, 443, '/list/');
    request.headers..add('Authorization', 'Bearer $token');

    await request.close();
  } finally {
    client.close();
  }
}
