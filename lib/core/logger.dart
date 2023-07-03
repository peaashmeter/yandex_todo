import 'dart:developer' as dev;

class Logger {
  static Logger? instance;
  Logger._() : number = 0;
  factory Logger() {
    instance ??= Logger._();
    return instance!;
  }

  int number;

  void log(Object e, StackTrace s) {
    dev.log(e.toString(),
        time: DateTime.now(), sequenceNumber: number, stackTrace: s);
  }
}
