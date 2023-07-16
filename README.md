# Список задач (ШМР 2023)
Фичи:
* Можно добавлять задачи
* Можно удалять задачи
* Можно редактировать задачи
* Задачи сохраняются на сервер и в файлик
* Написано на чистом Flutter без использования сторонних библиотек (ну почти).

Для запуска:
1. создать файл `config.json` в корне проекта
2. задать в нем `{"token" : <ваш токен>}`


Аналогично с тестами: `flutter test --dart-define-from-file=config.json`
К слову об автогенерации тестов: юнит-тестирование написано с помощью ChatGPT, рекомендую. Пример промпта:
```dart
Write a group of unit-tests in flutter to test these functions:
1. Future<(int, List<Task>)?> listTasks()
2. Future<(int, List<Task>)?> updateTasks(List<Task> tasks, int revision)
3. Future<(int, Task)?> getTaskbyId(String id)
4. Future<int?> addTask(Task task, int revision)
5. Future<int?> updateTask(Task task, int revision)
6. Future<int?> deleteTask(String id, int revision)

The syntax (int, List) stands for a tuple of two values with said types. You can access these fields using tuple.$1 and tuple.$2.
First of all, call the first function and store both fields of a tuple as variables. Then increase the integer by one and pass it into the second function.
After that, call the other functions.
Use this Task object when applicable: Task t = Task(importance: Importance.low, text: 'test', done: false, id: '42');
Use '42' as id when needed.
```
Важно объяснить нейросети про то, как работают Records, она про них еще не знает.

Скачать apk можно [тут](https://github.com/peaashmeter/yandex_todo/releases/download/v1.2.0/app-release.apk).

| <img src="https://github.com/peaashmeter/yandex_todo/blob/main/screenshots/1.png" width="300">  |  <img src="https://github.com/peaashmeter/yandex_todo/blob/main/screenshots/2.png" width="300"> |
|:-:|---|


