import 'package:flutter/material.dart';

class CollapseModel extends InheritedWidget {
  final bool isCollapsed;

  const CollapseModel(
      {super.key, required this.isCollapsed, required super.child});

  @override
  bool updateShouldNotify(CollapseModel oldWidget) =>
      isCollapsed != oldWidget.isCollapsed;
}

class CollapseNotification extends Notification {
  final bool isCollapsed;

  CollapseNotification(this.isCollapsed);
}
