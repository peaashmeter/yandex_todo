import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:yandex_todo/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Добавление новой задачи', () {
    testWidgets('Переходим на экран добавления, пишем текст, сохраняем задачу',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final Finder fab = find.widgetWithIcon(FloatingActionButton, Icons.add);
      await tester.tap(fab);
      await tester.pumpAndSettle();
      final Finder textField = find.byType(TextFormField);
      await tester.enterText(textField, 'test task');
      await tester.pumpAndSettle();
      final Finder save = find.widgetWithText(TextButton, 'СОХРАНИТЬ');
      await tester.tap(save);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 5));

      expect(find.text('test task'), findsOneWidget);
    });
  });
}
