import 'package:flutter/material.dart';

class MainScreenModel extends InheritedWidget {
  final bool isCollapsed;
  final bool showCompleted;
  const MainScreenModel(
      {super.key,
      required this.showCompleted,
      required this.isCollapsed,
      required super.child});

  @override
  bool updateShouldNotify(MainScreenModel oldWidget) => oldWidget != this;
}

class CollapseNotification extends Notification {
  final bool isCollapsed;

  CollapseNotification(this.isCollapsed);
}

class SwitchFilterNotification extends Notification {
  final bool showCompleted;

  SwitchFilterNotification(this.showCompleted);
}
