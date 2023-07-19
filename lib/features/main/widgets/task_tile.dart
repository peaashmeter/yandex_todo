import 'package:flutter/material.dart';
import 'package:yandex_todo/core/data.dart';
import 'package:yandex_todo/core/navigator.dart';
import 'package:yandex_todo/features/task/task_model.dart';
import 'package:yandex_todo/core/util.dart';

class TaskTile extends StatelessWidget {
  final String id;
  final Task task;
  const TaskTile({super.key, required this.id, required this.task});

  @override
  Widget build(BuildContext context) {
    final dataModel = DataModel.maybeOf(context);
    assert(dataModel != null);

    return Dismissible(
      onDismissed: (direction) => _deleteTask(context),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _markAsCompleted(context);
          return false;
        }
        return true;
      },
      background: Container(
        color: Colors.green,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.centerLeft, child: Icon(Icons.done_rounded)),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete_rounded)),
        ),
      ),
      key: ValueKey(id),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.surface,
        leading: Checkbox(
            value: dataModel!.getTasks()[id]?.done,
            onChanged: (value) => _markAsCompleted(context)),
        isThreeLine: true,
        title: Text(
          task.text,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          dataModel.getTasks()[id]?.deadline?.simpleString ?? '',
        ),
        trailing: IconButton(
            onPressed: () => BetterNavigator.of(context).toExistingTask(id),
            icon: const Icon(Icons.info_outline_rounded)),
      ),
    );
  }

  _deleteTask(BuildContext context) =>
      DataModel.maybeOf(context)?.removeTask(id);
  _markAsCompleted(BuildContext context) =>
      DataModel.maybeOf(context)?.completeTask(id);
}
