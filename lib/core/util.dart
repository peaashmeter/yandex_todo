extension ReadableDateTime on DateTime {
  String get simpleString => '$day ${_getMonth(month)} $year';
  String _getMonth(int n) => switch (n) {
        1 => 'января',
        2 => 'февраля',
        3 => 'марта',
        4 => 'апреля',
        5 => 'мая',
        6 => 'июня',
        7 => 'июля',
        8 => 'августа',
        9 => 'сентября',
        10 => 'октября',
        11 => 'ноября',
        12 => 'декабря',
        _ => throw ArgumentError('Не может у нас быть таких месяцев!!!')
      };
}
