import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yandex_todo/core/data.dart';
import 'package:yandex_todo/core/network.dart';
import 'package:yandex_todo/core/persistence.dart';

///Тест сценария, при котором приложение не имеет доступа к интернету
///После появления сети данные обновляются до свежей ревизии
void main() {
  test('No connection', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel(
      'plugins.flutter.io/path_provider',
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (message) async => './test/data',
    );
    init();

    final dummy = () async => null;
    final rev1 = await DataNotifier().init(dummy, readTasks);
    final rev2 = await DataNotifier().init(listTasks, readTasks);

    expect(rev1, lessThanOrEqualTo(rev2));
  });
}
