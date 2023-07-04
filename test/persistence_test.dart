import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yandex_todo/core/persistence.dart';
import 'package:yandex_todo/features/task/task_model.dart';

void main() {
  group('Тест работы с локальными данными', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel(
      'plugins.flutter.io/path_provider',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (message) async => './test/data',
    );

    test('File initialization', () async {
      final result = await init();
      expect(result, true);
    });
    test('File deletion', () async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/tasks.json');
      await file.delete();
      final result = await init();
      expect(result, true);
    });

    test('Update tasks', () async {
      final result = await updateTasks([
        Task(importance: Importance.low, text: 'test', done: false, id: '42')
      ], 42);
      expect(result, true);
    });

    test('Read tasks', () async {
      final result = await readTasks();
      expect(result!.$2[0].id, '42');
    });
  });
}
