///Работа с бэкендом здесь
///TODO: избавиться от дублирования кода в функциях
///(использовать либу http не предлагать 🤡)
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:yandex_todo/features/task/task_model.dart';

final baseurl = Uri.https('beta.mrdekk.ru', '/todobackend/list');
const _token = String.fromEnvironment('token');

Future<(int, List<Task>)> listTasks() async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(baseurl);
    request.headers.add('Authorization', 'Bearer $_token');
    final response = await request.close();

    final data = await response.transform(utf8.decoder).join();
    final json = jsonDecode(data) as Map;

    final tasks = (json['list'] as List).map((e) => Task.fromJson(e)).toList();
    final revision = json['revision'] as int;
    return (revision, tasks);
  } finally {
    client.close();
  }
}

Future<(int, Task)> getTaskbyId(String id) async {
  final client = HttpClient();
  final url = baseurl.replace(path: 'todobackend/list/$id');
  try {
    final request = await client.getUrl(url);
    request.headers.add('Authorization', 'Bearer $_token');
    final response = await request.close();

    final data = await response.transform(utf8.decoder).join();
    final json = jsonDecode(data) as Map;
    return (json['revision'] as int, Task.fromJson(json));
  } finally {
    client.close();
  }
}

Future<int> addTask(Task task, int revision) async {
  final client = HttpClient();
  try {
    final request = await client.postUrl(baseurl);
    request.headers
      ..add('Authorization', 'Bearer $_token')
      ..add('X-Last-Known-Revision', revision);
    final body = jsonEncode({'element': task.toJson()});
    request.write(body);

    final response = await request.close();
    final data = await response.transform(utf8.decoder).join();
    final json = jsonDecode(data) as Map;
    return json['revision'] as int;
  } finally {
    client.close();
  }
}

Future<int> updateTask(Task task, int revision) async {
  final client = HttpClient();
  final url = baseurl.replace(path: 'todobackend/list/${task.id}');
  try {
    final request = await client.putUrl(url);
    request.headers
      ..add('Authorization', 'Bearer $_token')
      ..add('X-Last-Known-Revision', revision);
    final body = jsonEncode({'element': task.toJson()});
    request.write(body);

    final response = await request.close();

    final data = await response.transform(utf8.decoder).join();
    final json = jsonDecode(data) as Map;
    return json['revision'] as int;
  } finally {
    client.close();
  }
}

Future<int> deleteTask(String id, int revision) async {
  final client = HttpClient();
  final url = baseurl.replace(path: 'todobackend/list/$id');
  try {
    final request = await client.deleteUrl(url);
    request.headers
      ..add('Authorization', 'Bearer $_token')
      ..add('X-Last-Known-Revision', revision);

    final response = await request.close();
    final data = await response.transform(utf8.decoder).join();
    final json = jsonDecode(data) as Map;
    return json['revision'] as int;
  } finally {
    client.close();
  }
}
