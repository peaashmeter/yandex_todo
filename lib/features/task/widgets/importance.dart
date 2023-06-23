import 'package:flutter/material.dart';

import '../task_model.dart';

class ImportanceTile extends StatefulWidget {
  const ImportanceTile({
    super.key,
  });

  @override
  State<ImportanceTile> createState() => _ImportanceTileState();
}

class _ImportanceTileState extends State<ImportanceTile> {
  @override
  Widget build(BuildContext context) {
    final MenuController controller = MenuController();
    final importance = TaskModel.of(context).task.importance;

    return InkWell(
      onTap: () => controller.open(),
      child: ListTile(
        title: Text(
          'Важность',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: MenuAnchor(
            controller: controller,
            menuChildren: [
              ImportanceMenuButton(
                importance: Importance.lowest,
                menuContext: context,
              ),
              ImportanceMenuButton(
                importance: Importance.low,
                menuContext: context,
              ),
              ImportanceMenuButton(
                importance: Importance.high,
                menuContext: context,
              ),
            ],
            child: Text(
              importance.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: importance == Importance.high ? Colors.red : null),
            )),
      ),
    );
  }
}

class ImportanceMenuButton extends StatelessWidget {
  final Importance importance;

  ///Нужно для посылки уведомлений в основное дерево виджетов
  final BuildContext menuContext;
  const ImportanceMenuButton(
      {super.key, required this.importance, required this.menuContext});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      onPressed: () => UpdateTaskNotification(importance).dispatch(menuContext),
      child: Text(importance.text),
    );
  }
}
