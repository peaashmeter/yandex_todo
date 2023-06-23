import 'package:flutter/material.dart';
import 'package:yandex_todo/core/data.dart';

import '../task_model.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dataModel = DataModel.maybeOf(context)!;
    final id = TaskModel.of(context).task.id;

    return TextButton.icon(
        onPressed: id == null
            ? null
            : () {
                Navigator.pop(context);
                dataModel.removeTask(id);
              },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        label: const Text(
          'Удалить',
          style: TextStyle(color: Colors.red),
        ));
  }
}
