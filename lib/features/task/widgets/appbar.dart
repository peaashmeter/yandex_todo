import 'package:flutter/material.dart';
import 'package:yandex_todo/core/data.dart';
import 'package:yandex_todo/features/task/task_model.dart';

class TaskAppBar extends StatelessWidget {
  const TaskAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dataModel = DataModel.maybeOf(context);
    final taskModel = TaskModel.of(context);

    assert(dataModel != null);
    return SliverAppBar(
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close)),
      actions: [
        TextButton(
            onPressed: () {
              taskModel.id == null
                  ? dataModel!.addTask(
                      DateTime.timestamp().millisecondsSinceEpoch, taskModel)
                  : dataModel!.editTask(taskModel.id!, taskModel);
              Navigator.pop(context);
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