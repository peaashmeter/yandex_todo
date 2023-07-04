import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:yandex_todo/core/logger.dart';
import 'package:yandex_todo/features/task/task_model.dart';

///Существует 4 возможных ситуации:
///1. доступны и локальные, и облачные данные:
///- если ревизии совпадают (идеальный случай), не делаем ничего
///- если ревизии не совпадают, обновляем старую копию до новой
///2. доступны только локальные данные (нет интернета):
///- приложение сохраняет данные локально, ошибки доступа к сети ловятся и логируются,
///при перезапуске с интернетом наступает случай 1.
///3. доступны только облачные данные (произошел баг):
///- приложение остается функциональным, запись только в облако
///4. никакие данные недоступны:
///- приложение становится бесполезным и висит на загрузке (by design).
///
///Управлением ревизиями занимается класс DataNotifier, чтобы избежать перекрестных зависимостей.

File? _storage;

Future<bool> init() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    _storage = File('${dir.path}/tasks.json');

    if (!await _storage!.exists() || _storage!.readAsBytesSync().isEmpty) {
      await _storage!.create(recursive: true);
      final initialData = {
        'revision': 0,
        'list': [],
      };

      await _storage!.writeAsString(jsonEncode(initialData));
    }

    return true;
  } catch (e, s) {
    Logger().log(e, s);
    return false;
  }
}

Future<bool> updateTasks(Iterable<Task> tasks, int revision) async {
  assert(
      _storage != null, 'Нужно вызвать init() перед началом работы с данными.');
  try {
    final out = _storage!.openWrite();
    final data = {
      'revision': revision,
      'list': tasks.map((e) => e.toJson()).toList()
    };
    out.write(jsonEncode(data));
    out.close();
    return true;
  } catch (e, s) {
    Logger().log(e, s);
    return false;
  }
}

Future<(int revision, List<Task> tasks)?> readTasks() async {
  assert(
      _storage != null, 'Нужно вызвать init() перед началом работы с данными.');
  try {
    final data = await _storage!.readAsString();
    if (data.isEmpty) return null;
    final json = jsonDecode(data);

    return (
      json['revision'] as int,
      (json['list'] as List?)?.map((e) => Task.fromJson(e)).toList() ?? []
    );
  } catch (e, s) {
    Logger().log(e, s);
    return null;
  }
}
