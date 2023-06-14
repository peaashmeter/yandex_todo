import 'package:flutter/material.dart';
import 'package:yandex_todo/features/task/util.dart';

import '../task_model.dart';

class DateTile extends StatefulWidget {
  const DateTile({
    super.key,
  });

  @override
  State<DateTile> createState() => _DateTileState();
}

class _DateTileState extends State<DateTile> {
  late bool isActive;

  @override
  void didChangeDependencies() {
    final due = TaskModel.of(context).due;
    isActive = due != null;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final due = TaskModel.of(context).due;
    return InkWell(
      onTap: () => isActive
          ? showDatePicker(
              context: context,
              initialDate: due ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2077),
            ).then((value) => value != null ? _bubbleNotification(value) : null)
          : null,
      child: ListTile(
        title: Text(
          'Сделать до',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          isActive && due != null ? due.simpleString : '',
          style: const TextStyle(color: Colors.blue),
        ),
        trailing: Switch(
            value: isActive,
            onChanged: (value) {
              setState(() {
                isActive = value;
                if (!value) {
                  _bubbleNotification(null);
                } else {
                  _bubbleNotification(DateTime.now());
                }
              });
            }),
      ),
    );
  }

  _bubbleNotification(DateTime? d) {
    UpdateTaskNotification(d).dispatch(context);
  }
}
