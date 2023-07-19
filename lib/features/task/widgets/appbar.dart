import 'package:flutter/material.dart';
import 'package:yandex_todo/core/data.dart';
import 'package:yandex_todo/core/navigator.dart';
import 'package:yandex_todo/features/task/task_model.dart';

class TaskAppBar extends StatelessWidget {
  const TaskAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dataModel = DataModel.maybeOf(context);
    final task = TaskModel.of(context).task;

    assert(dataModel != null);
    return SliverAppBar(
      leading: IconButton(
          onPressed: () => BetterNavigator.of(context).back(),
          icon: const Icon(Icons.close)),
      actions: [
        TextButton(
            onPressed: () {
              if (task.id == null) {
                final id =
                    DateTime.timestamp().millisecondsSinceEpoch.toString();
                final t = task.copyWith(id: id);
                dataModel!.addTask(id, t);
              } else {
                dataModel!.editTask(task.id!, task);
              }

              BetterNavigator.of(context).back();
            },
            child: Text(
              'СОХРАНИТЬ',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).primaryColor),
            )),
      ],
      pinned: true,
      floating: true,
    );
  }
}
